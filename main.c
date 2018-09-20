#include <stdint.h>
#define UART1_RTX ((volatile uint32_t *)0x101f1000)

#define USER_STACK_SIZE 4000


void task_init(char *stack, void (*f)(void))
{

	char *top_stack = stack + USER_STACK_SIZE;
	*((uint32_t *)(top_stack - 4)) = (uint32_t)f;
}


void printk(const char *str)
{
	while (*str) {
		*(UART1_RTX) = (*str & 0xFF);
		str++;
	}
}

void sleep(int count)
{
	while(count--);
}

char task_stack[USER_STACK_SIZE];
uint32_t t_sp = (uint32_t)(task_stack + USER_STACK_SIZE - 14 * 4);
void process()
{

	while(1) {
		printk("process 1\n");
		svc_call(t_sp);
	}
}

char task_stack2[USER_STACK_SIZE];
uint32_t t_sp2 = (uint32_t)(task_stack2 + USER_STACK_SIZE - 14 * 4);
void process2()
{
	while(1) {
		printk("process 2\n");
		svc_call(t_sp2);
	}
}

void main()
{
	printk("os start!\n");
	task_init(task_stack, process);
	task_init(task_stack2, process2);

	while(1) {
		active(t_sp);
		sleep(80000000);
		active(t_sp2);
	}
}
