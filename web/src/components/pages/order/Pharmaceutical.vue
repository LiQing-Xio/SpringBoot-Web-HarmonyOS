<template>
    <div>
        <el-card class="box-card">
            <div class="mod-role">
                <el-form :inline="true" :model="dataForm" class="demo-form-inline">
                    <el-form-item>
                        <el-input v-model="dataForm.drugname" clearable placeholder="药品名称"></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-button @click="getDataList">查询</el-button>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="openDialog()">新增</el-button>
                    </el-form-item>
                </el-form>
                <el-table :data="dataList" border style="width: 100%">
                    <el-table-column type="selection" width="55"> </el-table-column>
                    <el-table-column prop="id" label="药品ID">
                    </el-table-column>
                    <el-table-column prop="drugname" label="患者姓名">

                    </el-table-column>
                    <el-table-column prop="manufacturer" label="生产厂家">
                    </el-table-column>
                    <el-table-column prop="batchnumber" label="生产批号">
                    </el-table-column>
                    <el-table-column prop="specification" label="规格">
                    </el-table-column>
                    <el-table-column prop="price" label="价格/元">
                    </el-table-column>
                    <el-table-column prop="number" label="数量">
                    </el-table-column>
                    <el-table-column prop="status" label="状态">
                        <template slot-scope="scope">
                            <span>{{ scope.row.status == 1 ? '日期正常' : '过期' }}</span>
                        </template>
                    </el-table-column>

                    <el-table-column label="操作" width="250">
                        <template slot-scope="scope">
                            <el-button size="mini" type="primary"
                                @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
                            <el-button size="mini" type="danger"
                                @click="handleDelete(scope.$index, scope.row)">删除</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <el-pagination @size-change="sizeChangeHandle" @current-change="currentChangeHandle"
                    :current-page="pageIndex" :page-sizes="[5, 10, 20, 50, 100]" :page-size="pageSize"
                    :total="totalPage" layout="total, sizes, prev, pager, next, jumper" style="margin-top: 30px">
                </el-pagination>
            </div>


            <el-dialog :title="dataDialogForm.id === 0 ? '入库药品信息' : '更新药品信息'" width="35%"
                :visible.sync="dialogFormVisible" @close="closeDialog()">
                <el-form :model="dataDialogForm" :rules="rules" ref="ruleForm">

                    <el-form-item label="药品名称" label-width="120px" prop="drugname">
                        <el-input v-model="dataDialogForm.drugname" placeholder="药品名称" style="width: 300px"></el-input>
                    </el-form-item>
                    <el-form-item label="生产厂家" label-width="120px" prop="manufacturer">
                        <el-input v-model="dataDialogForm.manufacturer" placeholder="生产厂家"
                            style="width: 300px"></el-input>
                    </el-form-item>
                    <el-form-item label="生产批号" label-width="120px" prop="batchnumber">
                        <el-input v-model="dataDialogForm.batchnumber" placeholder="生产批号"
                            style="width: 300px"></el-input>
                    </el-form-item>
                    <el-form-item label="规格" label-width="120px" prop="specification">
                        <el-input v-model="dataDialogForm.specification" placeholder="规格"
                            style="width: 300px"></el-input>
                    </el-form-item>
                    <el-form-item label="采购价格/元" label-width="120px" prop="price">
                        <el-input v-model="dataDialogForm.price" placeholder="采购价格" style="width: 300px"></el-input>
                    </el-form-item>
                    <el-form-item label="数量" label-width="120px" prop="number">
                        <el-input v-model="dataDialogForm.number" placeholder="数量" style="width: 300px"></el-input>
                    </el-form-item>
                    <el-form-item label="状态" label-width="120px" prop="status">
                        <el-select v-model="dataDialogForm.status" placeholder="状态">
                            <el-option v-for="item in StatusList" :label="item.label" :value="item.value"
                                :key="item.value"></el-option>
                        </el-select>
                    </el-form-item>


                </el-form>
                <div slot="footer" class="dialog-footer">
                    <el-button @click="dialogFormVisible = false">取 消</el-button>
                    <el-button type="primary" @click="handleSubmitFormData('ruleForm')">确 定</el-button>
                </div>
            </el-dialog>


        </el-card>
    </div>
</template>
<script>
export default {
    name: "Patient",
    data() {
        var checkusername = (rule, value, callback) => {
            if (this.dataDialogForm.id !== 0) {
                if (value === "") {
                    callback(new Error("请输入药品名"));
                }
                // 说明是更新操作
                callback();
            } else if (value === "") {
                callback(new Error("请输入药品名"));
            } else {

                callback();
            }
        };
        return {
            dataForm: {
                username: "",
            },
            dataList: [],
            StatusList: [
                {
                    label: '日期正常',
                    value: 1
                }, {
                    label: '过期',
                    value: 0

                }
            ],
            dialogFormVisible: false,
            pageIndex: 1,
            pageSize: 5,
            totalPage: 0,
            dataListLoading: false,
            dialogFormSubmitVisible: false,

            dataDialogForm: {
                id: 0,
                drugname: "",
                manufacturer: "",
                batchnumber: "",
                specification: "",
                price: "",
                number: "",
                status: 1,
            },
            rules: {
                drugname: [
                    { required: true, message: "请输入药品名", trigger: "blur" },
                    { validator: checkusername, trigger: "blur" }],

            },
        };
    },

    methods: {
        handleDelete(index, row) {
            // 删除角色信息
            this.$confirm("此操作将永久该记录, 是否继续?", "提示", {
                confirmButtonText: "确定",
                cancelButtonText: "取消",
                type: "warning",
            }).then(() => {
                if (this.dialogFormSubmitVisible) {
                    return;
                }
                this.dialogFormSubmitVisible = true;
                this.$http
                    .get("/drug/drug/deleteDrug?id=" + row.id)
                    .then((res) => {
                        console.log(res)
                        if (res.data.data === '0') {
                            // 表示数据不能被删除
                            this.$message({
                                type: "warning",
                                message: "该条记录不允许删除!",
                            });
                        } else {
                            this.$message({
                                type: "success",
                                message: "删除成功!",
                            });
                        }
                        this.dialogFormSubmitVisible = false;
                        // 刷新数据
                        this.getDataList();
                    });
            })
                .catch(() => {
                    this.dialogFormSubmitVisible = false;
                    this.$message({
                        type: "info",
                        message: "已取消删除",


                    });
                });
        },
        sizeChangeHandle(val) {
            this.pageSize = val;
            this.pageIndex = 1;
            this.getDataList();
        },
        openDialog() {
            this.dialogFormVisible = true;
        },
        handleEdit(index, row) {

            this.$http
                .get("/drug/drug/queryPhaById?id=" + row.id)
                .then((res) => {
                    const user = res.data.data;
                    // this.roles = res.data.data.roles;
                    // this.roleIds=user.roleIds
                    // 绑定需要更新的数据
                    console.log(user)
                    this.dataDialogForm = {
                        id: user.id,
                        drugname: user.drugname,
                        manufacturer: user.manufacturer,
                        batchnumber: user.batchnumber,
                        specification: user.specification,
                        price: user.price,
                        number: user.number,
                        status: user.status,
                    };
                    this.dialogFormVisible = true;
                })

        },
        handleSubmitFormData(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    if (this.dialogFormSubmitVisible) {
                        return;
                    }
                    this.dialogFormSubmitVisible = true;
                    this.$http
                        .post("/drug/drug/save", this.dataDialogForm)
                        .then((res) => {
                            this.dialogFormVisible = false; // 关闭窗口
                            // 清空添加数据的表单
                            this.dataDialogForm = {

                            };
                            this.dialogFormSubmitVisible = false;
                            // 刷新数据
                            this.getDataList();
                        });
                } else {
                    // console.log('error submit!!');
                    return false;
                }
            });
        },
        currentChangeHandle(val) {
            this.pageIndex = val;
            this.getDataList();
        },
        closeDialog() {
            this.dataDialogForm = {
                id: 0,
            };
        },
        getDataList() {
            if (this.dataListLoading) {
                return;
            }
            this.dataListLoading = true;
            // 声明params 查询的参数
            const params = {
                params: {
                    drugName: this.dataForm.drugname,
                    pageIndex: this.pageIndex,
                    pageSize: this.pageSize,
                },
            };
            this.$http.get("/drug/drug/list", params).then((res) => {
                this.dataList = res.data.data.list;
                this.totalPage = res.data.data.totalCount;
                this.dataListLoading = false;
            });
        },
    }, mounted() {
        this.getDataList();
    }
};
</script>