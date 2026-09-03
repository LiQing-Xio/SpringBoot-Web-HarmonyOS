package com.yx.pat.entity;

public enum Age {

    AGE_10_20("10-20", 10L),
    AGE_21_30("21-30", 21L),
    AGE_31_40("31-40", 31L),
    AGE_41_50("41-50", 41L),
    AGE_51_60("51-60", 51L),
    AGE_61_70("61-70", 61L),
    AGE_70_ADD("71+", 71L);

    private final String label;
    private final Long value; // 改为 Long 类型

    Age(String label, Long value) { // 构造参数类型改为 Long
        this.label = label;
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public Long getValue() { // 返回类型改为 Long
        return value;
    }
}
