// SysUser - 系统用户
export interface SysUser {
  userId?: number;
  username?: string;
  password?: string;
  salt?: string;
  email?: string;
  mobile?: string;
  status?: number;
  createUserId?: number;
  roleIds?: number[];
  createTime?: string;
}

// SysRole - 系统角色
export interface SysRole {
  roleId?: number;
  roleName?: string;
  remark?: string;
  createUserId?: number;
  createTime?: string;
  menuIds?: number[];
}

// Patient - 患者
export interface Patient {
  id?: number;
  username?: string;
  phone?: number;
  sex?: string;
  age?: number;
  hf?: string;
  healthTag?: string;
  createTime?: string;
  idCard?: string;
  address?: string;
  bioodType?: string;
  genetic?: string;
  allergy?: string;
}

// Patienta - 患者(挂号相关)
export interface Patienta {
  id?: number;
  username?: string;
  phone?: number;
  sex?: string;
  age?: number;
  rid?: number;
  symptoms?: string;
  healthTag?: string;
  createTime?: string;
  idCard?: string;
  address?: string;
  bioodType?: string;
  genetic?: string;
  allergy?: string;
  hf?: string;
}

// Doctor - 站点
export interface Doctor {
  id?: number;
  sid?: number;
  dname?: string;
  good?: string;
  exp?: string;
  title?: string;
}

// Drug - 药品
export interface Drug {
  id?: number;
  drugname?: string;
  manufacturer?: string;
  batchnumber?: string;
  specification?: string;
  price?: number;
  number?: number;
  status?: number;
}

// Bulletin - 公告
export interface Bulletin {
  id?: number;
  content?: string;
  date?: string;
  account?: string;
  type?: string;
}

// Know - 健康知识
export interface Know {
  id?: number;
  name?: string;
  img?: string;
  content?: string;
  type?: string;
}

// Yytx - 用药提醒
export interface Yytx {
  id?: number;
  newReminder?: string;
  time?: string;
}

// DataChart - 数据图表
export interface DataChart {
  id?: number;
  age?: string;
  value?: number;
  chartType?: string;
  date?: string;
  email?: string;
  unionads?: string;
  videods?: string;
  direct?: string;
  searchengine?: string;
}

// Healthknowledge - 健康常识
export interface Healthknowledge {
  id?: number;
  title?: string;
  content?: string;
}

// Registration - 挂号
export interface Registration {
  rid?: number;
  symptoms?: string;
}

// ShowMenu - 菜单
export interface ShowMenu {
  path?: string;
  name?: string;
  label?: string;
  icon?: string;
  url?: string;
  children?: ShowMenu[];
}

// PageUtils - 分页返回
export interface PageResult {
  totalCount?: number;
  pageSize?: number;
  totalPage?: number;
  currPage?: number;
  list?: object[];
}

// 通用响应
export interface ApiResponse {
  code?: number | string;
  msg?: string;
  message?: string;
  data?: object | object[] | string;
}

// 登录请求
export interface LoginRequest {
  username: string;
  password: string;
}
