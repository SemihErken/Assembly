SSEG 	SEGMENT PARA STACK 'STACK'
	DW 64 DUP (?)
SSEG 	ENDS
                      
DSEG	SEGMENT PARA 'DATA'
CR	EQU 13
LF	EQU 10
ISIM    DB CR, LF,'                                                SEMIH ERKEN 19011503',0
ELEMAN	DB CR, LF,'Kac Elemanli Bir Dizi Girmek Istersiniz : ',0
DEGER	DB CR, LF, 'Deger Giriniz ', 0
EKLEME  DB CR, LF, 'Kac Eleman Eklemek Istersiniz : ',0
MENU1	DB CR, LF, 'Dizi Olusturmak Icin 1 e Basiniz ', 0
MENU2	DB CR, LF, 'Olusturdugunuz Diziyi ve Linkleri Goruntulemek Icin 2 ye Basiniz ', 0
MENU3	DB CR, LF, 'Ekleme Yapmak Icin 3 e Basiniz ', 0
MENU4   DB CR, LF, 'Cikis Icin 4 e Basiniz ', 0
HATA	DB CR, LF, 'Dikkat !!! Sayi vermediniz yeniden giris yapiniz.!!!  ', 0
GECERSIZ DB CR, LF, 'Lutfen 1,2,3 ya da 4 Degerlerinden Birini Giriniz ', 0 
ALT     DB CR, LF, ' ', 0
BOSLUK  DB ' ',0
SECIM   DW 0
N       DW 1 
DIZI	DW 100 DUP(0)
LINK	DW 100 DUP(?)
MAX     DW 1
MIN     DW 0
MAX_INDIS  DW 0
MIN_INDIS  DW 0
MEVCUT_INDIS DW 0
COUNTER  DW  0 
INDIS    DW  0
SON_INDIS DW 0

DSEG 	ENDS 

CSEG 	SEGMENT PARA 'CODE'
	ASSUME CS:CSEG, DS:DSEG, SS:SSEG
	
ANA PROC FAR
    
    PUSH DS
    XOR AX,AX
    PUSH AX
    
    MOV AX,DSEG
    MOV DS,AX
    
    YANLIS:
    
          
    MENUYE_DON_TERMINAL5:
    
    MOV AX,OFFSET ISIM
    CALL PUT_STR         
     
    MOV AX,OFFSET MENU1                        ;KULLANICIYA SECENEKLER SUNUP SECIMINI ALIP ONA GORE ISLEM YAPIYORUZ
    CALL PUT_STR
    
    MOV AX,OFFSET ALT 
    CALL PUT_STR     
     
    MOV AX,OFFSET MENU2 
    CALL PUT_STR     
    
    MOV AX,OFFSET ALT 
    CALL PUT_STR
     
    MOV AX,OFFSET MENU3 
    CALL PUT_STR
    
    MOV AX,OFFSET ALT 
    CALL PUT_STR
    
    MOV AX,OFFSET MENU4 
    CALL PUT_STR
    
    MOV AX,OFFSET ALT 
    CALL PUT_STR
    
    
                    
    CALL GETN                                ; KULLANICIDAN ALDIGIMIZ SAYIYI CMP ILE DENETLEYIP 
    MOV SECIM,AX                             ; ILGILI BOLUMLERE AKTARIYORUZ
                
    CMP SECIM,1            
    JE SECIM1            
    
    CMP SECIM,2
    JE  SECIM2_TERMINAL0
    
    CMP SECIM,3            
    JE  SECIM3           
    
    CMP SECIM,4
    JE  SECIM4_TERMINAL0
    
    MOV AX,OFFSET GECERSIZ                   ; KULLANICI 1,2,3 VEYA 4 GIRMEDIGI TAKDIRDE UYARI VERIP YUKARI
    CALL PUT_STR                             ; GERI GONDERIYORUZ
    
    JMP YANLIS                
    SECIM1:
    MOV AX,OFFSET ISIM
    CALL PUT_STR            
    MOV AX, OFFSET ELEMAN  
    CALL PUT_STR
        
    CALL GETN
    MOV N,AX    
    MOV CX,N    
    XOR SI,SI      
        DIZI_YERLESTIRME:
            MOV AX,OFFSET ISIM          ;ISIM SOYISIM NUMARA YAZDIRIYORUZ
            CALL PUT_STR    
            MOV AX, OFFSET  DEGER       ; KULLANICIDAN ELEMAN ALIYORUZ 
            CALL PUT_STR
            CALL GETN
            MOV DIZI[SI],AX             ; ALDIGIMIZ ELEMANI DIZIMIZIN ILGILI INDISINE ATIYORUZ            
            CMP SI,0                    ; KOSUL SAGLANIYORSA BU ILK ELEMANDIR
            JNE ILK_GIRIS_DEGIL
                        
                MOV LINK[SI],-2         ;ILK ELEMANIN LINKINI -2 OLARAK SET EDIYORUZ EN SON YAZDIRIRKEN BOLECEGIZ
                JMP CIK1
                
                SECIM3:       ;SECIM 3'DE ELEMAN EKLENDIGINDE BURADAN ARAYA SIKISTIRIYORUZ
                MOV AX,OFFSET ISIM
                CALL PUT_STR
                MOV AX, OFFSET EKLEME             
                CALL PUT_STR
                CALL GETN
                MOV CX,AX
                MOV SI,COUNTER
                ADD N,AX
                JMP DIZI_YERLESTIRME
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                SECIM2_TERMINAL0:
                JMP SECIM2_TERMINAL1
                SECIM4_TERMINAL0:
                JMP SECIM4_TERMINAL1
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                
               
            ILK_GIRIS_DEGIL:           ;IKINCI YA DA DIGER ELEMANLARDA BU ETIKETE ATLIYORUZ
            
            CMP SI,2                   ; EGER IKINCI ELEMANSA DEVAM EDIYORUZ
            JNE  TERMINAL1
                
                    MOV AX,DIZI[2]
                    
                    CMP AX,DIZI[0]                 ;ILK VE IKINCI ELEMANLARI MAX VEYA MIN OLARAK TESPIT
                    JGE BUYUK                      ;EDIP LINKLERINI GEREKTIGI SEKILDE AYARLIYORUZ 
                    
                    MOV BX,DIZI[2]
                    MOV MIN,BX
                    
                    MOV MIN_INDIS,SI
                    MOV MAX_INDIS,0
                    
                    MOV BX,DIZI[0]
                    MOV MAX,BX
                    
                    MOV BX,MAX_INDIS 
                    MOV LINK[SI],BX
                    
                    JMP DURUM1
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    BUYUK_TERMINAL4:
                    JMP DIZI_YERLESTIRME            ; DOSBOX BUYUK ATLAMALARA IZIN VERMEDIGI ICIN BIRDEN FAZLA 
                    SECIM2_TERMINAL1:               ; JUMP GEREKLI OLUYOR BUNUN ICIN DE KOSULSUZ DALLANMALARIN
                    JMP SECIM2_TERMINAL2            ; ALTINA GIRILMEDIGI ICIN ORALARI ATLAMA TERMINALI YAPIYORUZ 
                    MENUYE_DON_TERMINAL4:
                    JMP MENUYE_DON_TERMINAL5
                    SECIM4_TERMINAL1:
                    JMP SECIM4_TERMINAL2
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    BUYUK:                    
                    MOV AX,DIZI[2]
                    CMP AX,DIZI[0]
                    
                    JE ESIT
                    
                    MOV BX,DIZI[2]
                    MOV MAX,BX
                    
                    MOV MAX_INDIS,SI
                    
                    MOV MIN_INDIS,0
                    
                    MOV BX,DIZI[0]
                    MOV MIN,BX
                    
                    MOV BX,MAX_INDIS
                    MOV LINK[0],BX
                    
                    
                    MOV LINK[2],-2
                    
                    JMP DURUM2
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                TERMINAL1:
                JMP IKINCI_GIRIS_DEGIL
                SECIM2_TERMINAL2:
                JMP SECIM2_TERMINAL3
                MENUYE_DON_TERMINAL3:
                JMP MENUYE_DON_TERMINAL4
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        
                ESIT:
                
                    MOV AX,DIZI[2]            ; ILK VE IKINCI ELEMAN ESIT ISE BURADAN BIRISINI MAX BIRISINI
                    CMP AX,DIZI[0]            ; MIN OLARAK TAYIN EDIYORUZ LINKLERINI BUNA GORE AYARLIYORUZ 
                    JNE ESIT_DEGIL
                    
                    MOV LINK[SI],-2
                    MOV LINK[0],SI
                    
                    MOV BX,DIZI[SI]
                    MOV MAX,BX
                    
                    MOV BX,DIZI[0]
                    MOV MIN,BX
    			    
    			    MOV MIN_INDIS,0
    			    
    			    MOV MAX_INDIS,SI
            
            DURUM1:
            
            DURUM2:
                
            ESIT_DEGIL:
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
            JMP CIK2
            BUYUK_TERMINAL3:
            JMP BUYUK_TERMINAL4                     ; DOSBOX BUYUK ATLAMALARA IZIN VERMEDIGI ICIN BIRDEN FAZLA
            SECIM2_TERMINAL3:                       ; JUMP GEREKLI OLUYOR BUNUN ICIN DE KOSULSUZ DALLANMALARIN
            JMP SECIM2_TERMINAL4                    ; ALTINA GIRILMEDIGI ICIN ORALARI ATLAMA TERMINALI YAPIYORUZ
            MENUYE_DON_TERMINAL2:
            JMP MENUYE_DON_TERMINAL3
            SECIM4_TERMINAL2:
            JMP SECIM4_TERMINAL3
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            IKINCI_GIRIS_DEGIL:
            
            
            MOV AX,DIZI[SI]                         ; IKINCI GIRISTEN SONRAKI ELEMANLAR ICIN ONCE MAXTAN BUYUK
            CMP AX,MAX                              ; MU KUCUK MU KONTROLU YAPIYORUZ BUYUK ISE DIREKT ONU MAX
            JL MAXTAN_KUCUK                         ; OLARAK TAYIN EDIP LINKINI -2 YAPIP DIGER ELEMAN ALMA 
                                                    ; ISLEMINE GECIYORUZ
            
            MOV AX,DIZI[SI]
            MOV MAX,AX
            
            MOV DI,MAX_INDIS
            MOV LINK[DI],SI
            
            MOV MAX_INDIS,SI
            
            MOV LINK[SI],-2
            
            JMP ASAGI
                        
            MAXTAN_KUCUK:                            ;EGER ELEMANIMIZ MAXTAN KUCUKSE BU SEFER MIN'DEN KUCUK MU                           ;
                                                     ;DIYE KONTROL EDIYORUZ MINDEN DE KUCUK ISE YENI MIN DEGERIMIZ
            MOV AX,DIZI[SI]                          ;BU SAYI OLUYOR VE MIN DEGISKENINE ATIYORUZ ARDINDAN MIN_INDISI
            CMP AX,MIN                               ;BU SAYININ LINKINE ATIYORUZ CUNKU ESKI MIN SAYI , YENI MIN 
            JG MAXTAN_KUCUK_MINDEN_BUYUK             ;SAYIMIZDAN HEMEN SONRA GELEN SAYI OLMUS OLUYOR VE LINK ONU
                                                     ;ISARET ETMELI
            MOV AX,MIN_INDIS
            MOV LINK[SI],AX
            
            
            MOV MIN_INDIS,SI
            
            MOV AX,DIZI[SI]
            MOV MIN,AX
            
            JMP GIRME1
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            BUYUK_TERMINAL2:
            JMP BUYUK_TERMINAL3
            SECIM2_TERMINAL4:                       ; ATLAMA TERMINALI
            JMP YAZDIR
            MENUYE_DON_TERMINAL1:
            JMP MENUYE_DON_TERMINAL2
            SECIM4_TERMINAL3:
            JMP SECIM4_TERMINAL4
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            MAXTAN_KUCUK_MINDEN_BUYUK: 
            
            MOV AX,MIN_INDIS                        ; EGER SAYIMIZ MAX DEGER ILE MIN DEGER ARASINDA ISE 
            MOV MEVCUT_INDIS,AX                     ; MIN DEGERIN INDISINI MEVCUT INDIS OLARAK TAYIN EDIYORUZ KI
                                                    ; MIN DEGERDEN BASLAYARAK BUTUN DEGERLERLE KIYAS EDELIM
            PUSH CX
            
            MOV CX,SI
            SHR CX,1
            
                    DONGU1:                        
                                                   ; BU DONGUDE DIZI[MEVCUT_INDIS] ILE MIN DEGERDEN BASLAYARAK 
                    MOV DI,MEVCUT_INDIS            ; KIYAS EDIYORUZ EGER ELIMIZDEKI ELEMAN MEVCUT DEGERDEN BUYUKSE
                    MOV AX,DIZI[DI]                ; YA DA ESITSE DEVAM ETIKETINE ATLIYORUZ
                    CMP DIZI[SI],AX
                    JGE DEVAM
                    
                    MOV AX,MEVCUT_INDIS            ; EGER BAKTIGIMIZ DEGER MEVCUT DEGERDEN KUCUKSE ARTIK ATLADIGIMIZ
                    MOV LINK[SI],AX                ; SAYILARDAN SONRA YERINI BULDUK DEMEKTIR .MEVCUT DEGERDEN BUYUK 
                                                   ; OLDUGU DURUMLARDA OLUSTURDUGUMUZ SON INDISI ALIP LINKIN SON INDIS
                    MOV DI,SON_INDIS               ; LI DEGERINE SUANKI SAYIMIZIN INDISINI KOYUYORUZ VE KENDISINDEN
                    MOV LINK[DI],SI                ; KUCUK OLAN VE DIGER ELEMANLARDAN BUYUK OLAN SAYI ARTIK GIRILEN  
                                                   ; DEGERIN INDISINI GOSTERIYOR
                                                   
                    JMP DUR
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    BUYUK_TERMINAL1:
                    JMP BUYUK_TERMINAL2                   ;ATLAMA TERMINALI
                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                    DEVAM:                          ;ELIMIZDEKI DEGER MEVCUT DEGERDEN BUYUK OLDUGUNA GORE BIR SONRAKI
                                                    ;DEGERE BAKMAMIZ GEREKIYOR ANCAK SONRAKI DEGERE GECMEDEN ONCE 
                    MOV AX,MEVCUT_INDIS             ;MEVCUT DEGERIN INDISINI SON INDISTE TUTUYORUZ
                    MOV SON_INDIS,AX
                    
                    MOV DI,MEVCUT_INDIS             ;LINKIMIZDE MEVCUT INDISLI INDISTE BULUNAN DEGERI YENI MEVCUT
                    MOV AX,LINK[DI]                 ;INDISIMIZ YAPIYORUZ KI KIYASLADIGIMIZ DEGERDEN BIR BUYUK OLAN
                    MOV MEVCUT_INDIS,AX             ;DEGERE GECIP ONUNLA KIYASLAMA YAPABILELIM
                    
                    DUR:
                    LOOP DONGU1            
          POP CX
            
        ASAGI:    
        GIRME1:    
        CIK2:    
        CIK1:
        ADD COUNTER,2                              ; EKLEME YAPACAIGIMIZDA ONCEKI KAYITLARIN USTUNE YAZMAMAK ICIN
        ADD SI,2                                   ; COUNTER DEGISKENI TUTUYORUZ
        DEC CX
        
        CMP CX,0
        JE MENUYE_DON_TERMINAL1    
        JMP BUYUK_TERMINAL1
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;          
    
    YAZDIR:
    
    MOV CX,N
    XOR SI,SI
    
    MOV AX,OFFSET ISIM
    CALL PUT_STR   
    
    MOV AX,OFFSET ALT                           
    CALL PUT_STR
    
        DIZI_YAZDIRMA:                             ; DIZIMIZI YAZDIRIYORUZ                
        
            MOV AX, DIZI[SI]                
            CALL PUTN
            
            MOV AX,OFFSET BOSLUK
            CALL PUT_STR
            
            ADD SI,2 
            
        LOOP DIZI_YAZDIRMA;
        
        
    MOV AX,OFFSET ALT                           
    CALL PUT_STR    
        
    
    MOV CX,N
    XOR SI,SI    
        
        LINK_YAZDIRMA:
        
            MOV AX, LINK[SI]                         ; LINKLERIMIZI YAZDIRIYORUZ
            SAR AX,1               
            CALL PUTN
            MOV AX,OFFSET BOSLUK
            CALL PUT_STR
                           
            ADD SI,2 
            
        LOOP LINK_YAZDIRMA
        
        MOV AX,OFFSET ALT
        CALL PUT_STR
        
    JMP MENUYE_DON_TERMINAL1        
    SECIM4_TERMINAL4:
    RETF 
ANA ENDP
    
GETC	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden bas�lan karakteri AL yazmac�na al�r ve ekranda g�sterir. 
        ; i�lem sonucunda sadece AL etkilenir. 
        ;------------------------------------------------------------------------
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

PUTC	PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmac�ndaki de�eri ekranda g�sterir. DL ve AH de�i�iyor. AX ve DX 
        ; yazma�lar�n�n de�erleri korumak i�in PUSH/POP yap�l�r. 
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 

GETN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden bas�lan sayiyi okur, sonucu AX yazmac� �zerinden dondurur. 
        ; DX: say�n�n i�aretli olup/olmad���n� belirler. 1 (+), -1 (-) demek 
        ; BL: hane bilgisini tutar 
        ; CX: okunan say�n�n islenmesi s�ras�ndaki ara de�eri tutar. 
        ; AL: klavyeden okunan karakteri tutar (ASCII)
        ; AX zaten d�n�� de�eri olarak de�i�mek durumundad�r. Ancak di�er 
        ; yazma�lar�n �nceki de�erleri korunmal�d�r. 
        ;------------------------------------------------------------------------
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                        ; say�n�n �imdilik + oldu�unu varsayal�m 
        XOR BX, BX 	                        ; okuma yapmad� Hane 0 olur. 
        XOR CX,CX	                        ; ara toplam de�eri de 0�d�r. 
NEW:
        CALL GETC	                        ; klavyeden ilk de�eri AL�ye oku. 
        CMP AL,CR 
        JE FIN_READ	                        ; Enter tu�una basilmi� ise okuma biter
        CMP  AL, '-'	                        ; AL ,'-' mi geldi ? 
        JNE  CTRL_NUM	                        ; gelen 0-9 aras�nda bir say� m�?
NEGATIVE:
        MOV DX, -1	                        ; - bas�ld� ise say� negatif, DX=-1 olur
        JMP NEW
        
        		                        ; yeni haneyi al
CTRL_NUM:
        CMP AL, '0'	                        ; say�n�n 0-9 aras�nda oldu�unu kontrol et.
        JB error 
        CMP AL, '9'
        JA error		                ; de�il ise HATA mesaj� verilecek
        SUB AL,'0'	                        ; rakam al�nd�, haneyi toplama d�hil et 
        MOV BL, AL	                        ; BL�ye okunan haneyi koy 
        MOV AX, 10 	                        ; Haneyi eklerken *10 yap�lacak 
        PUSH DX		                        ; MUL komutu DX�i bozar i�aret i�in saklanmal�
        MUL CX		                        ; DX:AX = AX * CX
        POP DX		                        ; i�areti geri al 
        MOV CX, AX	                        ; CX deki ara de�er *10 yap�ld� 
        ADD CX, BX 	                        ; okunan haneyi ara de�ere ekle 
        JMP NEW 		                ; klavyeden yeni bas�lan de�eri al 
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                        ; HATA mesaj�n� g�ster 
        JMP GETN_START                          ; o ana kadar okunanlar� unut yeniden say� almaya ba�la 
FIN_READ:
        MOV AX, CX	                        ; sonu� AX �zerinden d�necek 
        CMP DX, 1	                        ; ��arete g�re say�y� ayarlamak laz�m 
        JE FIN_GETN
        NEG AX		                        ; AX = -AX
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN 	ENDP 

PUTN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazd�r�r. 
        ; CX: haneleri 10�a b�lerek bulaca��z, CX=10 olacak
        ; DX: 32 b�lmede i�leme d�hil olacak. Soncu etkilemesin diye 0 olmal� 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit b�lmede soncu etkilemesin diye 0 olmal� 
        PUSH DX		                        ; haneleri ASCII karakter olarak y���nda saklayaca��z.
                                                ; Ka� haneyi alaca��m�z� bilmedi�imiz i�in y���na 0 
                                                ; de�eri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; say� negatif ise AX pozitif yap�l�r. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; i�areti ekrana yazd�r. 
        CALL PUTC
        POP AX		                        ; AX�i geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = b�l�m DX = kalan 
        ADD DX, '0'	                        ; kalan de�erini ASCII olarak bul 
        PUSH DX		                        ; y���na sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; b�len 0 kald� ise say�n�n i�lenmesi bitti demek
        JNE CALC_DIGITS	                        ; i�lemi tekrarla 
        
DISP_LOOP:
                                                ; yaz�lacak t�m haneler y���nda. En anlaml� hane �stte 
                                                ; en az anlaml� hane en alta ve onu alt�nda da 
                                                ; sona vard���m�z� anlamak i�in konan 0 de�eri var. 
        POP AX		                        ; s�rayla de�erleri y���ndan alal�m
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII de�eri yaz
        JMP DISP_LOOP                          ; i�leme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazd�r�r.
        ; BX dizgeye indis olarak kullan�l�r. �nceki de�eri saklanmal�d�r. 
        ;------------------------------------------------------------------------
	PUSH BX 
        MOV BX,	AX			        ; Adresi BX�e al 
        MOV AL, BYTE PTR [BX]	                ; AL�de ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			        ; 0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ; AL�deki karakteri ekrana yazar
        INC BX 				        ; bir sonraki karaktere ge�
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			        ; yazd�rmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP

CSEG 	ENDS 
	END ANA    