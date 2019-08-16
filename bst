#include<stdio.h> 
#include<stdlib.h> 
   
struct node 
{ 
    int key; 
    struct node *left, *right; 
}; 
   
// A utility function to create a new BST node 
struct node *newNode(int item) 
{ 
    struct node *temp =  (struct node *)malloc(sizeof(struct node)); 
    temp->key = item; 
    temp->left = temp->right = NULL; 
    return temp; 
} 
   
// A utility function to do inorder traversal of BST 
void inorder(struct node *root) 
{ 
    if (root != NULL) 
    { 
        inorder(root->left); 
        printf("%d \n", root->key); 
        inorder(root->right); 
    } 
} 
   
   
void del(struct node * root,int key)
{
	struct node* temp = root;
	struct node* prev;
	struct node* suc;
	if(temp != NULL){
		while(temp -> key != key){
		if(key < temp->key){
			prev = temp;
			temp = temp -> left;
		}
		
		else if(key > temp->key){
			prev = temp;
			temp = temp -> right;
		}
	}
	if(key == temp->key){
			if(temp->left == NULL && temp->right == NULL){
				if(prev->key > temp->key){
					prev->left=NULL;
					free(temp);	
				}
				else{
					prev->right=NULL;
					free(temp);
				}
				
			}
			
			else if((temp->left!=NULL && temp->right == NULL)){
				if(prev->key > temp->key){
					prev->left=temp->left;
					free(temp);	
				}
				else{
					prev->right=temp->left;
					free(temp);
				}
			
						
			}
			
			else if((temp->left==NULL && temp->right != NULL)){
				if(prev->key > temp->key){
					prev->left=temp->right;
					free(temp);	
				}
				else{
					prev->right=temp->right;
					free(temp);
				}
			
						
			}
			
			else{
				suc = inOrderSuccessor(root,temp->key);
			    printf("%d",suc->key);
			//	temp->key = succ->key;
				
				//temp->right ;
				
			}
		}
	}
}


struct node* inOrderSuccessor(struct node* root, int ky)
{
	struct node * succ;
	while(root->key != ky){
		if(ky > root->key ){
			root = root->right;
		}
		else if(ky < root->key ){
			root = root->left;
		}
	}
	
	succ = root->right;
	while(succ->left != NULL){
		succ = succ->left;
	}
	return succ;
}
/* A utility function to insert a new node with given key in BST */
struct node* insert(struct node* node, int key) 
{ 
    /* If the tree is empty, return a new node */
    if (node == NULL) return newNode(key); 
	if (key < node->key) 
        node->left  = insert(node->left, key); 
    else if (key > node->key) 
        node->right = insert(node->right, key);    
  
    /* return the (unchanged) node pointer */
    return node; 
} 
   
   

// Driver Program to test above functions 
int main() 
{ 
    /* Let us create following BST 
              50 
           /     \ 
          30      70 
         /  \    /  \ 
       20   40  60   80 */
    struct node *root = NULL; 
   // int ke,suc;
    root = insert(root, 50); 
    insert(root, 30); 
    insert(root, 20); 
    insert(root, 40); 
    insert(root, 70); 
    insert(root, 60); 
    insert(root, 80); 
   
    // print inoder traversal of the BST 
    inorder(root);
   // suc= inOrderSuccessor(root,50);
//	printf("Enter key to delete");
//	scanf("%d",&ke);
	//del(root,20);
//	printf("successor is : %d",suc);
	del(root,50);
	inorder(root);
    return 0; 
} 
