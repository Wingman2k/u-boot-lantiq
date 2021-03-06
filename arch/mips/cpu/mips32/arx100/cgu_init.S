/*
 * Copyright (C) 2007-2010 Lantiq Deutschland GmbH
 * Copyright (C) 2012-2013 Daniel Schwierzeck, daniel.schwierzeck@gmail.com
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */

#include <config.h>
#include <asm/asm.h>
#include <asm/regdef.h>
#include <asm/addrspace.h>
#include <asm/arch/soc.h>

/* CGU module register */
#define CGU_PLL0_CFG			0x0004	/* PLL0 config */
#define CGU_PLL1_CFG			0x0008	/* PLL1 config */
#define CGU_SYS				0x0010	/* System clock */
#define CGU_UPDATE			0x0014	/* Clock update control */

/* Valid SYS.PPE_SEL values */
#define CGU_SYS_PPESEL_SHIFT		7
#define CGU_SYS_PPESEL_250_MHZ		(0x1 << CGU_SYS_PPESEL_SHIFT)

/* Valid SYS.SYS_SEL values */
#define CGU_SYS_SYSSEL_SHIFT		3
#define CGU_SYS_SYSSEL_PLL0_333_MHZ	(0x0 << CGU_SYS_SYSSEL_SHIFT)
#define CGU_SYS_SYSSEL_PLL1_393_MHZ	(0x2 << CGU_SYS_SYSSEL_SHIFT)

/* Valid SYS.CPU_SEL values */
#define CGU_SYS_CPUSEL_SHIFT		2
#define CGU_SYS_CPUSEL_EQUAL_SYSCLK	(0x0 << CGU_SYS_CPUSEL_SHIFT)
#define CGU_SYS_CPUSEL_EQUAL_DDRCLK	(0x1 << CGU_SYS_CPUSEL_SHIFT)

/* Valid SYS.DDR_SEL values */
#define CGU_SYS_DDRSEL_HALF_SYSCLK	0x0
#define CGU_SYS_DDRSEL_THIRD_SYSCLK	0x1

#define CGU_UPDATE_UPD			0x1

#if (CONFIG_SYS_CLOCK_MODE == LTQ_CLK_CPU_393_DDR_197)
#define CGU_SYS_PPESEL_CONFIG		CGU_SYS_PPESEL_250_MHZ
#define CGU_SYS_SYSSEL_CONFIG		CGU_SYS_SYSSEL_PLL1_393_MHZ
#define CGU_SYS_CPUSEL_CONFIG		CGU_SYS_CPUSEL_EQUAL_SYSCLK
#define CGU_SYS_DDRSEL_CONFIG		CGU_SYS_DDRSEL_HALF_SYSCLK
#elif (CONFIG_SYS_CLOCK_MODE == LTQ_CLK_CPU_197_DDR_197)
#define CGU_SYS_PPESEL_CONFIG		CGU_SYS_PPESEL_250_MHZ
#define CGU_SYS_SYSSEL_CONFIG		CGU_SYS_SYSSEL_PLL1_393_MHZ
#define CGU_SYS_CPUSEL_CONFIG		CGU_SYS_CPUSEL_EQUAL_DDRCLK
#define CGU_SYS_DDRSEL_CONFIG		CGU_SYS_DDRSEL_HALF_SYSCLK
#elif (CONFIG_SYS_CLOCK_MODE == LTQ_CLK_CPU_333_DDR_167)
#define CGU_SYS_PPESEL_CONFIG		CGU_SYS_PPESEL_250_MHZ
#define CGU_SYS_SYSSEL_CONFIG		CGU_SYS_SYSSEL_PLL0_333_MHZ
#define CGU_SYS_CPUSEL_CONFIG		CGU_SYS_CPUSEL_EQUAL_SYSCLK
#define CGU_SYS_DDRSEL_CONFIG		CGU_SYS_DDRSEL_HALF_SYSCLK
#elif (CONFIG_SYS_CLOCK_MODE == LTQ_CLK_CPU_167_DDR_167)
#define CGU_SYS_PPESEL_CONFIG		CGU_SYS_PPESEL_250_MHZ
#define CGU_SYS_SYSSEL_CONFIG		CGU_SYS_SYSSEL_PLL0_333_MHZ
#define CGU_SYS_CPUSEL_CONFIG		CGU_SYS_CPUSEL_EQUAL_DDRCLK
#define CGU_SYS_DDRSEL_CONFIG		CGU_SYS_DDRSEL_HALF_SYSCLK
#elif (CONFIG_SYS_CLOCK_MODE == LTQ_CLK_CPU_131_DDR_131)
#define CGU_SYS_PPESEL_CONFIG		CGU_SYS_PPESEL_250_MHZ
#define CGU_SYS_SYSSEL_CONFIG		CGU_SYS_SYSSEL_PLL1_393_MHZ
#define CGU_SYS_CPUSEL_CONFIG		CGU_SYS_CPUSEL_EQUAL_DDRCLK
#define CGU_SYS_DDRSEL_CONFIG		CGU_SYS_DDRSEL_THIRD_SYSCLK
#elif (CONFIG_SYS_CLOCK_MODE == LTQ_CLK_CPU_111_DDR_111)
#define CGU_SYS_PPESEL_CONFIG		CGU_SYS_PPESEL_250_MHZ
#define CGU_SYS_SYSSEL_CONFIG		CGU_SYS_SYSSEL_PLL0_333_MHZ
#define CGU_SYS_CPUSEL_CONFIG		CGU_SYS_CPUSEL_EQUAL_DDRCLK
#define CGU_SYS_DDRSEL_CONFIG		CGU_SYS_DDRSEL_THIRD_SYSCLK
#else
#error "Invalid system clock configuration!"
#endif

/* Build register values */
#define CGU_SYS_VALUE		(CGU_SYS_PPESEL_CONFIG | \
				CGU_SYS_SYSSEL_CONFIG | \
				CGU_SYS_CPUSEL_CONFIG | \
				CGU_SYS_DDRSEL_CONFIG)

	.set noreorder

LEAF(ltq_cgu_init)
	/* Load current CGU register value */
	li	t0, (LTQ_CGU_BASE | KSEG1)
	lw	t1, CGU_SYS(t0)

	/* Load target CGU register values */
	li	t2, CGU_SYS_VALUE

	/* Only update registers if values differ */
	beq	t1, t2, finished
	 nop

	/* Store target register values */
	sw	t2, CGU_SYS(t0)

	/* Trigger CGU update */
	li	t1, CGU_UPDATE_UPD
	sw	t1, CGU_UPDATE(t0)

finished:
	jr	ra
	 nop

	END(ltq_cgu_init)
