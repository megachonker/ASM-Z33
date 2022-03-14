// x² − 2xy − y²

x: .word 50
y: .word 50

calcul:
    ld [%sp+1], %a  //%a = x
    push %b         //save %B
    mul %a,%a       //x²
    push %a         //save x²
    debugreg
                    //x et y 3 et 4 
    ld [%sp+4],%a   //ld y
    mul %a,%a       //y²
    push %a         //save y²
    debugreg
                    //x et y 4 et 5
    ld [%sp+4], %b  //charge x dans b
    mul 2,%b        //2x       dans b
    ld [%sp+5], %a  //charge y dans a
    mul %a,%b       //2xy dans %b
    ld [%sp+1],%a   //x² dans %a
    sub %b,%a       //x²-2xy² dans %a
    pop %b          //pop y² dans %b
    sub %b,%a       //x*x - (2*x*y - y*y) dans %a
    debugreg
    pop %b          //vide la pille
    pop %b          //remet le registre a
    rtn

main_calcul:
    ld [x], %a
    ld [y], %b
    push %b
    push %a
    debugreg
    call calcul
    debugreg
    reset
    

// produit scalair
vax: .word 9
vay: .word 8
vac: .word 7
vbx: .word 1
vby: .word 2
vbc: .word 3

prodscal:
    push %b
    push 0  // P contien le resulstat
    ld 0,%b //init le compteur
loop:
    jmp produit
    retour:
    add 1,%b // incrémente le conteur
    ld [%sp+5],%a
    cmp %b,%a
    debugreg
    jne loop    // }
    pop %a
    pop %b
    rtn

produit:
    //%b est l'indice
    ld  [%sp+3],%a  //on charge l'adresse du va du staque
    add %b,%a       //on shiff l'adresse de l'incice
    ld [%a],%a      //charge vecteur b
    push %a         //save le vecteur charger
    //on part du principe que les vecteur ne sont pas coller
    ld  [%sp+5],%a  //on charge l'adresse du va du staque
    add %b,%a       //on shiff l'adresse de l'incice
    ld [%a],%a      //charge vecteur a

    push %b         //on save l'incice
    ld [%sp+1],%b   //on charge la ligne du vecteur b
    mul %b,%a      //va.X*vb.X
    ld [%sp+2],%b   
    add %b,%a       //p+=
    pop %b          //on remet l'indice
    add 1,%sp
    st %a,[%sp] 
    debugreg
    jmp retour

main_prodscal:
    
    ld 69,%b
    //n taille vecteur
    push 3  


    //vecteur vb
    ld vax,%a
    push %a

    //vecteur va
    ld vbx,%a
    push %a

    call prodscal
    debugreg

    //depiler tout le bordell
    reset
    
main_racine:
    push 25
    call racine
    reset


//r = inf + (sup - inf)/2 ?
moyenne:
    sub %a,%b
    div 2,%b
    add %a,%b
    rtn

racine:
    push %b
    ld 1,%a      //inf
    ld [%sp+2],%b
    
    push %a //inf
    push %b //sup

    call moyenne

    push %b //r

    jmp while_loop

    after_while:
    pop %a
    add 2,%sp
    pop %b
    rtn

while_loop:

    //(r+1)*(r+1)
    add 1,%b
    mul %b,%b
    ld [%sp+5],%a//charge n
    cmp %b,%a
    jle while_if_2

    //r*r > n
    ld [%sp],%b//charge r
    mul %b,%b  //r²
    cmp %b,%a
    jgt while_if_1


    jmp after_while

while_if_1:
    ld [%sp],%a
    st %a,[%sp+1]
    jmp endif
while_if_2:
    ld [%sp],%a
    st %a,[%sp+2]
endif:
    ld [%sp+2],%a
    ld [%sp+1],%b
    call moyenne
    st %b,[%sp]    //metre b dans r
    jmp while_loop

