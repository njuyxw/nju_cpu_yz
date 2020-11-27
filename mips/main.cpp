#include"mips.h"

int main(int argc,char *argv[]){
    MIPS m("instructor");
    string file1="assemble";
    string file2="system.mif";
    if(argc>=3){
        file1=argv[1];
        file2 =argv[2];
    }
    string cho="-X";
    cout<<argc;
    if(argc>=4)
        cho=argv[3];
    m.convertToBinary(file1, file2,cho);
    return 0;
}