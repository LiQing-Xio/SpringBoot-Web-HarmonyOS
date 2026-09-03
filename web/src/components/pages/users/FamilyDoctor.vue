<template>
    <div class="family-doctor-intro">
      <header>
        <h1>家庭医生服务介绍</h1>
      </header>
      <section class="introduction">
        <h2>什么是家庭医生？</h2>
        <p>
          家庭医生是一种新型的医疗服务模式，旨在为服务对象提供全面、连续、有效、及时和个性化的医疗保健服务和照顾。
        </p>
      </section>
      <section class="policy-background">
        <h2>政策背景</h2>
        <ul>
          <li>
            <strong>2015年1月14日</strong>：北京市西城区副区长梁昌新在西城区人代会上介绍，正在试点“契约式家庭医生”服务，确保24小时内预约对口三甲医院的专家号，3天内安排就诊。
          </li>
          <li>
            <strong>2018年10月</strong>：国家卫生健康委发布《关于规范家庭医生签约服务管理的指导意见》，要求全国家庭医生团队依法依约为签约居民提供基础性和个性化签约服务，并提出十一项签约服务内容。
          </li>
        </ul>
      </section>
      <section class="statistics">
        <h2>统计数据</h2>
        <p>
          <strong>2022年5月</strong>：截至2021年底，全国共有<strong>143.5万</strong>家庭医生。
        </p>
      </section>
    </div>
  </template>
  
  <script>
  export default {
    name: 'FamilyDoctorIntro',
    data() {
      return {};
    },
  };
  </script>
  
  <style scoped>
  .family-doctor-intro {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    font-family: Arial, sans-serif;
  }
  
  header h1 {
    text-align: center;
    color: #333;
  }
  
  section {
    margin-bottom: 20px;
  }
  
  h2 {
    color: #555;
  }
  
  p, ul {
    line-height: 1.6;
    color: #666;
  }
  
  ul {
    padding-left: 20px;
  }
  
  li {
    margin-bottom: 10px;
  }
  </style>