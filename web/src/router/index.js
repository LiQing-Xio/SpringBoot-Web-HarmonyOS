import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/common/Home.vue'

import Patient from '@/components/pages/customer/Patient.vue'
import PatientFiles from '@/components/pages/customer/PatientFiles.vue'
import Pharmaceutical from '@/components/pages/order/Pharmaceutical.vue'
import Drugknowledgebase from '@/components/pages/order/Drugknowledgebase.vue'
import DrugknowledgebaseList from '@/components/pages/order/DrugknowledgebaseList.vue'
import FirstPage from '@/components/pages/FirstPage.vue'
import Login from '@/components/common/Login.vue'
import SysUser from '@/components/pages/sys/SysUser.vue'
import SysRole from '@/components/pages/sys/SysRole.vue'
import SysMap from '@/components/pages/sys/SysMap.vue'
import SysLog from '@/components/pages/sys/SysLog.vue'
import Test from '@/components/common/Test.vue'
import BulletinList from '@/components/pages/bulletin/BulletinList.vue'
import Registration from '@/components/pages/customer/Registration.vue'
import infomation from '@/components/pages/infomation.vue'
import UserLogin from '@/components/common/UserLogin.vue'
import Main from '@/components/pages/users/Main.vue'
import navigation from '@/components/pages/users/navigation.vue'
import registration1 from '@/components/pages/users/registration1.vue'
import Register from '@/components/pages/users/Register.vue'
import jkjl from '@/components/pages/users/jkjl.vue'
import HealthKnowledge from '@/components/pages/users/HealthKnowledge.vue'
import usersinfo from '@/components/pages/users/usersinfo.vue'
import bgsc from '@/components/pages/users/bgsc.vue'
import yytx from '@/components/pages/users/yytx.vue'
import FamilyDoctor from '@/components/pages/users/FamilyDoctor.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Home',// 主路由
      component: Home,
      redirect:'FirstPage',
      children: [ // 嵌套的子路由
      {
        path: '/FirstPage',
        name: 'firstPage',
        component: FirstPage
      },
        {
          path: '/Patient',
          name: 'Patient',
          component: Patient
        }, {
          path: '/PatientFiles',
          name: 'PatientFiles',
          component: PatientFiles
        }, {
          path: '/Registration',
          name: 'Registration',
          component: Registration
        }, 
        {
          path: '/Pharmaceutical',
          name: 'Pharmaceutical',
          component: Pharmaceutical
        }, {
          path: '/Drugknowledgebase',
          name: 'Drugknowledgebase',
          component: Drugknowledgebase
        },{
          path: '/SysUser',
          name: 'sysUser',
          component: SysUser
        }, {
          path: '/SysRole',
          name: 'sysRole',
          component: SysRole
        }, {
          path: '/BulletinList',
          name: 'BulletinList',
          component: BulletinList
        }
        , {
          path: '/SysMap',
          name: 'sysMap',
          component: SysMap
        }, {
          path: '/SysLog',
          name: 'sysLog',
          component: SysLog
        }, {
          path: '/DrugknowledgebaseList',
          name: 'DrugknowledgebaseList',
          component: DrugknowledgebaseList
        }
        ,{
          path: '/infomation',
          name: 'infomation',// 主路由
          component: infomation,
        }
      ]
    }
    ,{
      path: '/Login',
      name: 'login',// 主路由
      component: Login,
    },{
      path: '/UserLogin',
      name: 'UserLogin',// 主路由
      component: UserLogin,
    } ,{
      path: '/Test',
      name: 'test',// 主路由
      component: Test,
    }
    ,{
      path: '/Register',
      name: 'register',// 主路由
      component: Register,
    },
    {
      path: '/navigation',
      name: 'navigation',// 主路由
      component: navigation,
      children: [ // 嵌套的子路由
        {
          path: '/Main',
          name: 'Main',
          component: Main
        }
        ,
        {
          path: '/registration1',
          name: 'registration1',
          component: registration1
        },{
          path: '/jkjl',
          name: 'jkjl',// 主路由
          component: jkjl,
        },{
          path: '/HealthKnowledge',
          name: 'healthKnowledge',// 主路由
          component: HealthKnowledge,
        },{
          path: '/usersinfo',
          name: 'usersinfo',// 主路由
          component: usersinfo,
        },{
          path: '/bgsc',
          name: 'bgsc',// 主路由
          component: bgsc,
        },{
          path: '/yytx',
          name: 'yytx',// 主路由
          component: yytx,
        },{
          path: '/FamilyDoctor',
          name: 'familyDoctor',// 主路由
          component: FamilyDoctor,
        }
      
      ]
    }
    
  ]
})
