#include<stdio.h>
#include<string.h>

char* find_str_in_str(char *str1, char *str2)
{
/*    char *str1="abcdefghi";*/
/*    char *str2="abc";*/
    char *p;
    p = strstr(str1, str2);
    return p;
}
