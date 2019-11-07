#include <stdio.h>

#include <stdlib.h>
#include <malloc.h>
#define TRUE 1
#define FALSE 0
#define T 3        //degree of B Tree

typedef struct node
{

    struct node *child [2*T];
    int key[2*T-1];
    int n;      // current no. of keys in tree
    int leaf;
}node;

void traverse(node *root)
{                                                               //print all the value of a node then traverse child
    if(root)
    {
        int i;
        for(i=0; i < root->n; i++)
        {
            printf("%d\t",root->key[i]);

        }
        if(!root->leaf)
            {
                for(i=0; i<=root->n;i++)
                {
                    printf("\n%d\t",i);
                    traverse(root->child[i]);
                }

            }
    }

}

node *search(node* root, int value)
{
    if(root)
    {

        int i=0;
        while(i < root->n && value > root->key[i] )
        {
            i++;
        }
        if(i < root->n && value== root->key[i])
            return root;
         if(root->leaf)
        {
            return NULL;
        }

        return search(root->child[i],value);
    }
    return NULL;
}


node *splitChild(node *root, int i)     //child index of root
{

    node *y = root->child[i];
    node *z= (node*)malloc(sizeof(node));
    z->n= T-1;
    z->leaf = y->leaf;

    int j;
    for(j=0; j < T-1; j++)
    {
        z->key[j] = y->key[j+T];
    }

    if(!y->leaf)
    {

        for(j=0; j < T; j++)
        {
            z->child[j] = y->child[j+T];
        }
    }

    y->n = T-1;

    for(j=root->n; j> i; j--)
    {

        root->child[j+1] = root->child[j];

    }
    root->child[i+1] = z;

    for(j=root->n-1; j>=i; j--)
    {
        root->key[j+1]= root->key[j];
    }
    root->key[i]= y->key[T-1];
    root->n++;

    return root;
}

node* insertNonFull(node *root, int value)
{
    int i=root->n-1;

    if(root->leaf)
    {
        while(i >= 0 && value < root->key[i])
        {

            root->key[i+1]=root->key[i];
            i--;
        }
        root->key[i+1]= value;
        root->n++;
        return root;
    }
    else
    {
        while(i >= 0 && value < root->key[i])
        {
            i--;
        }
        i++;
        if(root->child[i]->n == 2*T-1)         //this check if any other node other than root is full
        {
            root = splitChild(root,i);
            if(value > root->key[i])
            {
                i++;
            }

        }
        root->child[i] = insertNonFull(root->child[i],value);

        return root;

    }

}



node *insert(node *root, int data)
{

    if(!root)
    {
       node *root= (node*)malloc(sizeof(node));
        root->key[0]=data;
        root->leaf=TRUE;
        root->n=1;

        return root;
    }
    else if(root->n==2*T-1)                     //this is to check if root node of BTree is full
    {

        node *temp= (node*)malloc(sizeof(node));
        temp->child[0]=root;                         // 1st child of new root
        temp->leaf=FALSE;
        temp->n=0;

        temp = splitChild(temp,0);

        temp = insertNonFull(temp,data);

        return temp;
    }
    else
    {

        root = insertNonFull(root,data);


    }


    return root;
}


int pred(node *root)
{
    while(!root->leaf)
    {
        root= root->child[root->n];
    }
    return root->key[root->n-1];
}


int succ(node *root)
{
    while(!root->leaf)
    {
        root=root->child[0];
    }
    return root->key[0];
}


node *merge(node *root, int i)
{
    node *y= root->child[i];
    node *z= root->child[i+1];
    int j;

    y->n = 2*T-1;
    y->key[T-1] = root->key[i];

    for(j=0; j< z->n; j++)
    {
        y->key[j+T] = z->key[j];
    }
    if(!y->leaf)
    {
        for(j=0; j< z->n; j++)
        {
            y->child[j+T] = z->child[j];
        }
    }

    free(z);

    for(j=i+1; j< root->n; j++)
    {
        root->key[j-1] = root->key[j];
    }



    for(j=i+1; j<root->n; j++)
    {
        root->child[j]= root->child[j+1];
    }

    root->child[i] = y;
    root->n--;

    return root;
}


node *takeFromPrev(node *root, int i)
{
    node *cur= root->child[i];
    node *prev= root->child[i-1];
    int temp= cur->n;
    int j;

    for(j=temp; j>0; j++)
    {
        cur->key[j]= cur->key[j-1];
    }

    cur->key[0]= root->key[i-1];

    if(!cur->leaf)
    {
        for(j=temp+1; j>0; j++)
        {
            cur->child[j] = cur->child[j-1];
        }
        cur->child[0] = prev->child[prev->n];
    }


    root->key[i-1] = prev->key[prev->n - 1];
    prev->n--;
    cur->n++;

    return root;


}


node *takeFromNext(node *root, int i)
{
    node *cur = root->child[i];
    node *next = root->child[i+1];
    int temp = cur->n;
    int j;

    cur->key[temp] = root->key[i];

    if(!cur->leaf)
    {
        cur->child[temp+1] = next->child[0];
    }


    root->key[i] =  next->key[0];

    for(j=1; j<next->n; j++)
    {
        next->key[j-1] = next->key[j];
    }

    if(!next->leaf)
    {
        for(j=1; j<=next->n; j++)
        {
            next->child[j-1]= next->child[j];
        }
    }

    next->n--;
    cur->n++;

    return root;
}




node *delete(node *root, int data)
{
    int i=0;
    while(i < root->n && data > root->key[i])
    {
        i++;
    }

    if(root->leaf)
    {

        if(i<root->n && data == root->key[i])               //case 1
        {
            while(i < root->n)
            {
                root->key[i]= root->key[i+1];
                i++;
            }
            root->n--;
        }

        else
        {
            printf("%d is not present in the B Tree\n",data);
            return root;
        }
    }

    else
    {
        if(i<root->n && data == root->key[i])    //inside the node      // case2
        {
            if(root->child[i]->n > T-1)             //case 2a
            {
                int temp = pred(root->child[i]);
                root = delete(root,temp);
                root->key[i]=temp;
            }
            else if(root->child[i+1]->n > T-1)          //case 2b
            {
                int temp = succ(root->child[i+1]);
                root=delete(root,temp);
                root->key[i]=temp;
            }
            else                                        //case 2c
            {

                root = merge(root,i);
                root->child[i] = delete(root->child[i],data);

            }

        }
        else
        {

            if(root->child[i]->n == T-1)            //case 3
            {
                if(i>0 && root->child[i-1]->n > T-1)            //case 3a
                {
                    root = takeFromPrev(root,i);
                }
                else if(i<root->n && root->child[i+1]->n > T-1)     //case 3b
                {
                    root = takeFromNext(root,i);
                }
                else                                                //case 3c
                {
                    root= merge(root,i);
                }
            }

            root->child[i] = delete(root->child[i],data);

        }
    }
    if(root->n == 0)                    // case when root has no key
    {
        root = root->child[0];
    }

    return root;

}



int main()
{
    node *root = NULL;
    /*root= insert(root,5);
    root= insert(root,9);
    root= insert(root,3);
    root= insert(root,7);
    root= insert(root,1);                   //Test Case I with T=2
    root= insert(root,2);
    root= insert(root,8);
    root= insert(root,6);
    root= insert(root,0);
    root= insert(root,4);*/
    root= insert(root,20);
    root= insert(root,10);
    root= insert(root,50);
    root= insert(root,40);
    root= insert(root,30);
    root= insert(root,60);
    root= insert(root,80);
    root= insert(root,70);
    root= insert(root,90);
    root= insert(root,100);
    root= insert(root,110);             //test case 2 with T=3
    root= insert(root,120);
    root= insert(root,130);
    root= insert(root,140);
    root= insert(root,150);
    root= insert(root,160);
    root= insert(root,170);
    root= insert(root,180);
    root= insert(root,190);
    root= insert(root,200);
    root= insert(root,210);
    root = delete(root,60);

    printf("%d\n",root->n);

    traverse(root);


    return 0;
}

