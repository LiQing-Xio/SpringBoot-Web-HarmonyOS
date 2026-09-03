export default{
    state:{
        // 控制菜单栏的状态
        isCollapse:false,
        tabsList:[// 面包屑数据
            {
                path:'/',
                name:'firstPage',
                label:'首页',
                icon:'s-home',
                url:'firstPage'
            }
        ]
    },
    mutations:{
        collapseChange(state){
            state.isCollapse = !state.isCollapse
        },menuChange(state,val){
            // 更新面包屑的数据 val 菜单对象数据
            if(val.name !== 'main'){
                const index = state.tabsList.findIndex(item => item.name === val.name)
                if(index === -1){
                    state.tabsList.push(val)
                }
            }
        },closeTag(state,val){
            const index = state.tabsList.findIndex(item => item.name === val.name)
            state.tabsList.splice(index,1)
        }
    }
}