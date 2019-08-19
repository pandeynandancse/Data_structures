/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#include<stdlib.h>
struct node {
    struct node* left;
    int key;
    struct node* right;
};

struct node* createNode(int key){
    struct node* newnode = (struct node*)malloc(sizeof(struct node));
    newnode->left=NULL;
    newnode->key=key;
    newnode->right=NULL;
    return newnode;
}

struct node* insertInBst(struct node* root,int key)
{
    if(root==NULL){
        struct node* newnode;
        newnode = createNode(key);
        root = newnode;
        return root;
    }   
    
    else{
        if(root->key > key){
            root->left = insertInBst(root->left,key);
        }
        else{
            root->right = insertInBst(root->right,key);
        }
        return root;
    }
}


void preorder(struct node* root){
    
    if(root==NULL){
        return;
    }    
    else{
        printf("%d",root->key);
        preorder(root->left);
        preorder(root->right);
    }
}

void postorder(struct node* root){
    if(root==NULL){
        return;
    }
    else{
        postorder(root->left);
        postorder(root->right);
        printf("%d",root->key);
    }
}

void inorder(struct node* root){
    if(root==NULL){
        return;
    }
    else{
        inorder(root->left);
        printf("%d",root->key);
        inorder(root->right);
    }
}



struct node* succesor(struct node* root)
{
    struct node* succ= root->right;
    while(succ->left!=  NULL){
        succ = succ->left;
    }
    return succ;
        
}



struct node* delete(struct node* root, int key)
{
    if(root==NULL){
        return root;
    }    
    
    else{
        
        if(root->key < key){
            root->right = delete(root->right,key);
        }
        
        else if(root->key > key){
            root->left = delete(root->left,key);
        }
        
        else{
            if(root->left==NULL){
                struct node* temp = root->right;
                free(root);
                return temp;
            }
            
            else if(root->right==NULL){
                struct node* temp = root->left;
                free(root);
                return temp; 
            }
            else{
                struct node* temp = succesor(root);
                root->key = temp->key;
                root->right = delete(root->right,temp->key); 
            }
        }
        
        return root;
    }
}


int height(struct node* root){
    if(root==NULL){
        return 0;
    }    
    
    else{
        int lheight = height(root->left);
        int rheight = height(root->right);
        
        if(lheight > rheight){
            return lheight + 1;
        }
        else{
            return rheight + 1;
        }
    }
}



int zeronode(struct node* root)
{
    if(root==NULL)
    {
        return 0;
    }
    
    else{
        if(root->left ==NULL && root->right ==NULL){
            return 1;
        }
        
        else return zeronode(root->left) + zeronode(root ->right);
    }
}


int totalnode(struct node* root)
{
    
    if(root==NULL){
        return 0;
    }
    
    else{
        return 1 + totalnode(root->left) + totalnode(root->right);
    }
}

/*int onenode(struct node* root){
    
    if(root==NULL)
    {
        return 0;
    }
    
    else{
        if((root->left !=NULL && root->right ==NULL) || (root->left ==NULL && root->right !=NULL)){
            return 1;
        }
        
        else return onenode(root->left) + onenode(root ->right);
    }
    
}


int twonode(struct node* root){
    
    if(root==NULL)
    {
        return 0;
    }
    
    else{
        if(root->left !=NULL && root->right !=NULL){
            return 1;
        }
        
        else return twonode(root->left) + twonode(root ->right);
    }
    
}
*/

int main()
{
    int keyi ,nodes,i;
    struct node* root =NULL;
    printf("enter number of nodes");
    scanf("%d",&nodes);
    for(i=0;i<nodes;i++){
        scanf("%d",&keyi);
        root = insertInBst(root,keyi);
    }
   /* printf("Preorder :");
    preorder(root);
    printf("\n");
    printf("Postorder");
    postorder(root);
    printf("\n");
    printf("Inorder");
    inorder(root);
    printf("\n");
    //levelorder(root);
    printf("deleting node with zero child :");
    root = delete(root,3);
    printf("\n");
    inorder(root);
    printf("Inserted 3 so that node 4 has 1 child");
    root = insertBST(root,3);
    root = delete(root,4);
    inorder(root);
    printf("\n");
    printf("Deleting node 10 which has two child");
    root = delete(root,10);
    inorder(root);
    printf("\n");
    */
    
    int heigh = height(root);
    printf("%d" , heigh);
    printf("\n");
    int zeronodes = zeronode(root);
    printf("%d",zeronodes);
    printf("\n");
    /*int onenodes = onenode(root);
    printf("%d",onenodes);
    printf("\n");
    
    twonodes = twonode(root);
    printf("%d",twonodes);
    printf("\n");
    
    */
    
    int totalnodes = totalnode(root);
    printf("%d",totalnodes);
    printf("\n");
    return 0;
    
    
}
