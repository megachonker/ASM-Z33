// x² − 2xy − y²

x: .word 50
y: .word 50

fact:
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

main:
    ld [x], %a
    ld [y], %b
    push %b
    push %a
    debugreg
    call fact
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
    push 0  // P contien le resulstat
    ld 0,%b //init le compteur
loop:
    jmp produit
    retour:
    add 1,%b // incrémente le conteur
    ld [%sp+2],%a
    cmp %b,%a
    debugreg
    jne loop    // }
    pop %a
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

main:
    
    //vecteur vb
    ld vax,%a
    push %a

    //vecteur va
    ld vbx,%a
    push %a
    
    //n taille vecteur
    push 3  

    call prodscal
    debugreg
    //depiler tout le bordell
    reset
    