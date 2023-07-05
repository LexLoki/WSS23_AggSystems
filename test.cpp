#include<bits/stdc++.h>

using namespace std;

typedef struct node
{
    pair<int, int> cellCoords;
    unordered_set<pair<int, int>> existingCells;
    //unordered_set<pair<int, int>> openCells;
}Node;

typedef struct treeNode
{
    int cx, cy;
    vector<struct treeNode*> children;
}TreeNode;

const int test_adj[4][2] = {{1,0}, {-1,0}, {0, 1}, {0, -1}};

struct hashFunction
{
  size_t operator()(const pair<bool, 
                    bool> &x) const
  {
    return x.first ^ x.second;
  }
};

TreeNode *dfs_level(int level, int cx, int cy, unordered_set<pair<int, int>, hashFunction> &cells, unordered_set<pair<int, int>, hashFunction> &openList)
{
    TreeNode *nd = new TreeNode();
    nd->cx = cx;
    nd->cy = cy;
    vector<pair<int, int>> tempPairList;
    if(!level) return nd;

    list<pair<int, int>> listIt(openList.begin(), openList.end());
    for(auto cell : listIt)
    {
        tempPairList.clear(); //confirm
        //Update open list
        for(int i=0;i<4;i++)
        {
            pair<int, int> newCell = make_pair(cell.first + test_adj[i][0], cell.second + test_adj[i][1]);
            if(cells.find(newCell) != cells.end()) continue;
            tempPairList.push_back(newCell);
            openList.insert(newCell);
        }
        cells.insert(cell);
        //check to not break iterator
        openList.erase(cell);
        nd->children.push_back(dfs_level(level-1, cell.first, cell.second, cells, openList));
        cells.erase(cell);
        openList.insert(cell);
        for(auto &mp : tempPairList)
        {
            openList.erase(mp);
        }
    }
    return nd;
}

void print_tree(TreeNode *node)
{
    cout << "Coords: " << node->cx << ' ' << node->cy << endl;
    cout << "childCount: " << node->children.size() << endl;
    for(auto &nd : node->children) print_tree(nd);
}

int main(void)
{
    unordered_set<pair<int, int>, hashFunction> allCells, leafCells, nextLevel;
    //unordered_set<pair<int, int>> leafCells,
    //unordered_set<pair<int, int>> nextLevel;
    pair<int, int> origin = make_pair(0, 0);
    //allCells = new unordered_set<pair<int, int>>({});
    //nextLevel = new unordered_set<pair<int, int>>(origin);
    nextLevel.insert(origin);
    //nextLevel = new(origin);
    //allCells = new(origin);
    //leafCells = new(origin);
    vector<vector<int>> edges;

    TreeNode *root = dfs_level(10, 0, 0, allCells, nextLevel);

    //cout << root->cx << ' ' << root->cy << ' ' << root->children.size() << endl;
    //print_tree(root);

    return 0;

    /*
    const int vis[4][2] = {{1,0}, {-1,0}, {0, 1}, {0, -1}};
    int quant = 2;
    while(quant--)
    {
        for(auto cell : leafCells)
        {
            nextLevel = new();
            for(int i=0;i<4;i++)
            {
                pair<int, int> newCell = make_pair(cell.first + vis[i][0], cell.second + vis[i][1]);
                if(allCells->find(newCell) != allCells->end()) continue;
                allCells->insert(newCell);
                nextLevel->insert(newCell);
            }
            delete leafCells;
            leafCells = nextLevel;
        }
    }*/
    return 0;
}

/*
    1 + 2 + 4 + ...
*/