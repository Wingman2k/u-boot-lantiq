/*
 * This file is released under the terms of GPL v2 and any later version.
 * See the file COPYING in the root directory of the source tree for details.
 *
 * Copyright (C) 2011-2013 Daniel Schwierzeck, daniel.schwierzeck@gmail.com
 */

#ifndef __LANTIQ_CHIPID_H__
#define __LANTIQ_CHIPID_H__

enum ltq_chip_partnum {
	LTQ_SOC_UNKNOWN = 0,
	LTQ_SOC_VRX288_2 = 0x000B,	/* VRX288 v1.2 */
	LTQ_SOC_VRX268_2 = 0x000C,	/* VRX268 v1.2 */
	LTQ_SOC_GRX288_2 = 0x000D,	/* GRX288 v1.2 */
	LTQ_SOC_DANUBE = 0x0129,
	LTQ_SOC_DANUBE_S = 0x012B,
	LTQ_SOC_TWINPASS = 0x012D,
	LTQ_SOC_VRX288 = 0x01C0,	/* VRX288 v1.1 */
	LTQ_SOC_VRX268 = 0x01C2,	/* VRX268 v1.1 */
	LTQ_SOC_GRX288 = 0x01C9,	/* GRX288 v1.1 */
};

extern unsigned int ltq_chip_version_get(void);
extern unsigned int ltq_chip_partnum_get(void);
extern const char *ltq_chip_partnum_str(void);

extern void ltq_chip_print_info(void);

#ifdef CONFIG_SOC_XWAY_DANUBE
static inline int ltq_soc_is_danube(void)
{
	return 1;
}
#else
static inline int ltq_soc_is_danube(void)
{
	return 0;
}
#endif

#ifdef CONFIG_SOC_XWAY_VRX200
static inline int ltq_soc_is_vrx200(void)
{
	return 1;
}

static inline int ltq_soc_is_vrx200_v1(void)
{
	return ltq_chip_version_get() == 1;
}

static inline int ltq_soc_is_vrx200_v2(void)
{
	return ltq_chip_version_get() == 2;
}
#else
static inline int ltq_soc_is_vrx200(void)
{
	return 0;
}

static inline int ltq_soc_is_vrx200_v1(void)
{
	return 0;
}

static inline int ltq_soc_is_vrx200_v2(void)
{
	return 0;
}
#endif

#endif /* __LANTIQ_CHIPID_H__ */