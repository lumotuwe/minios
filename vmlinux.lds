OUTPUT_ARCH(arm)
ENTRY(stext)
SECTIONS
{
	.text :
	{	
		*(.head.text)
		*(.text)
		*(.text.*)
	}

	.data :
	{
		*(.head.data)
		*(.data)
		*(.data.*)
		*(.rodata)
	}

	.bss :
	{
		*(.bss)
	}

	. = ALIGN(4);
	. = . + 0x1000; /*4kb stack memory*/
	stack_top = .;
}
