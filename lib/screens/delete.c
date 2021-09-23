#include <stdio.h>

char operatorStack[100];
int top = -1;
int precedenceFromChar(char opr){
    if(opr == '^'){
        return 3;
    }else if(opr == '*' || opr == '/'){
        return 2;
    }else if(opr == '+' || opr == '-'){
        return 1;
    }
    return 0;
}

int evaluatePostfix(char* exp)
{
    int variableStack[100];
    int variableStackTop = -1;
    for (int i = 0; exp[i] != '\0'; i++)
    {
        if (precedenceFromChar(exp[i]) == 0){
            variableStack[++variableStackTop] = exp[i]-'0';
        }
        else
        {
            int a = variableStack[variableStackTop--];
            int b = variableStack[variableStackTop--];
            switch (exp[i])
            {
                case '+': 
                variableStack[++variableStackTop] = a+b;
                break;
                case '-': 
                variableStack[++variableStackTop] = b-1;
                break;
                case '*': 
                variableStack[++variableStackTop] = a*b;
                break;
                case '/': 
                variableStack[++variableStackTop] = b/a;
                break;
            }
        }
    }
    return variableStack[variableStackTop--];
}
 

int main()
{
    char expression[100];
    printf("Enter the expression: ");
    scanf("%s", expression);
    char postfixExpression[100];
    int index = 0;
    for(int i = 0; expression[i] != '\0'; i++){
        if(expression[i] == '('){
            operatorStack[++top] = '(';
        }else if(expression[i] == ')'){
            while(operatorStack[top] != '('){
                postfixExpression[index] = operatorStack[top--];
                index++;
            }
            top--;
        }
        else if(precedenceFromChar(expression[i]) > 0){
            while(precedenceFromChar(expression[i]) <= precedenceFromChar(operatorStack[top]) && top != -1){
                postfixExpression[index] = operatorStack[top--];
                index++;
            }
            operatorStack[++top] = expression[i];
        }else {
            postfixExpression[index] = expression[i];
            index++;
        }
    }
    while(top != -1){
        postfixExpression[index] = operatorStack[top--];
        index++;
    }
    postfixExpression[index] = '\0';
    printf("%s", postfixExpression);
    printf("\nEvaluation of Expression:");
    printf("%d", evaluatePostfix(postfixExpression));
    return 0;
}