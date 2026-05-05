// https://github.com/CostinV92/SimpleDS3231
#ifndef __DS3231_H__
#define __DS3231_H__

/* Device address */
#define DS3231_ADDR                 0x68

/* Device registers */
/* Data registers */
#define DS3231_SEC_REG              0x00
#define DS3231_MIN_REG              0x01
#define DS3231_HOU_REG              0x02
#define DS3231_DOW_REG              0x03
#define DS3231_DAY_REG              0x04
#define DS3231_MON_REG              0x05
#define DS3231_YEAR_REG             0x06
#define DS3231_NO_DATA_REG          0x07

/* Alarm registers */
#define DS3231_ALM1_SEC_REG         0x07
#define DS3231_ALM1_MIN_REG         0x08
#define DS3231_ALM1_HOU_REG         0x09
#define DS3231_ALM1_DAY_REG         0x0A
#define DS3231_ALM1_DAT_REG         0x0A

#define DS3231_ALM2_MIN_REG         0x0B
#define DS3231_ALM2_HOU_REG         0x0C
#define DS3231_ALM2_DAY_REG         0x0D
#define DS3231_ALM2_DAT_REG         0x0D

/* Control registers */
#define DS3231_CONTROL_REG          0x0E
#define DS3231_CTL_STA_REG          0x0F
#define DS3231_AGN_OFF_REG          0x10
#define DS3231_MSB_TMP_REG          0x11
#define DS3231_LSB_TMP_REG          0x12

#endif /* __DS3231_H__ */
