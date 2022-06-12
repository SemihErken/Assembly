SSEG 	SEGMENT PARA STACK 'STACK'
	DW 64 DUP (?)
SSEG 	ENDS
                      
DSEG	SEGMENT PARA 'DATA'
CR	EQU 13
LF	EQU 10
ISIM    DB CR, LF,'                                                SEMIH ERKEN 19011503',0
ELEMAN	DB CR, LF,'How Many Elements Would You Enter To Your Array : ',0
DEGER	DB CR, LF, 'Enter Value ', 0
EKLEME  DB CR, LF, 'How Many Elements You Want To Add : ',0
MENU1	DB CR, LF, 'Press 1 to Create an Array ', 0
MENU2	DB CR, LF, 'Press 2 to View Arrays and Links That You Have Been Created ', 0
MENU3	DB CR, LF, 'Press 3 to Add Elements ', 0
MENU4   DB CR, LF, 'Press 4 to Exit ', 0
HATA	DB CR, LF, 'WARNING , You Did Not Entered Number Try Again  ', 0
GECERSIZ DB CR, LF, 'Please Enter 1,2,3 or 4 ', 0 
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
        ; Klavyeden basılan karakteri AL yazmacına alır ve ekranda gösterir. 
        ; işlem sonucunda sadece AL etkilenir. 
        ;------------------------------------------------------------------------
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

PUTC	PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmacındaki değeri ekranda gösterir. DL ve AH değişiyor. AX ve DX 
        ; yazmaçlarının değerleri korumak için PUSH/POP yapılır. 
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
        ; Klavyeden basılan sayiyi okur, sonucu AX yazmacı üzerinden dondurur. 
        ; DX: sayının işaretli olup/olmadığını belirler. 1 (+), -1 (-) demek 
        ; BL: hane bilgisini tutar 
        ; CX: okunan sayının islenmesi sırasındaki ara değeri tutar. 
        ; AL: klavyeden okunan karakteri tutar (ASCII)
        ; AX zaten dönüş değeri olarak değişmek durumundadır. Ancak diğer 
        ; yazmaçların önceki değerleri korunmalıdır. 
        ;------------------------------------------------------------------------
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                        ; sayının şimdilik + olduğunu varsayalım 
        XOR BX, BX 	                        ; okuma yapmadı Hane 0 olur. 
        XOR CX,CX	                        ; ara toplam değeri de 0dır. 
NEW:
        CALL GETC	                        ; klavyeden ilk değeri ALye oku. 
        CMP AL,CR 
        JE FIN_READ	                        ; Enter tuşuna basilmiş ise okuma biter
        CMP  AL, '-'	                        ; AL ,'-' mi geldi ? 
        JNE  CTRL_NUM	                        ; gelen 0-9 arasında bir sayı mı?
NEGATIVE:
        MOV DX, -1	                        ; - basıldı ise sayı negatif, DX=-1 olur
        JMP NEW
        
        		                        ; yeni haneyi al
CTRL_NUM:
        CMP AL, '0'	                        ; sayının 0-9 arasında olduğunu kontrol et.
        JB error 
        CMP AL, '9'
        JA error		                ; değil ise HATA mesajı verilecek
        SUB AL,'0'	                        ; rakam alındı, haneyi toplama dâhil et 
        MOV BL, AL	                        ; BLye okunan haneyi koy 
        MOV AX, 10 	                        ; Haneyi eklerken *10 yapılacak 
        PUSH DX		                        ; MUL komutu DXi bozar işaret için saklanmalı
        MUL CX		                        ; DX:AX = AX * CX
        POP DX		                        ; işareti geri al 
        MOV CX, AX	                        ; CX deki ara değer *10 yapıldı 
        ADD CX, BX 	                        ; okunan haneyi ara değere ekle 
        JMP NEW 		                ; klavyeden yeni basılan değeri al 
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                        ; HATA mesajını göster 
        JMP GETN_START                          ; o ana kadar okunanları unut yeniden sayı almaya başla 
FIN_READ:
        MOV AX, CX	                        ; sonuç AX üzerinden dönecek 
        CMP DX, 1	                        ; İşarete göre sayıyı ayarlamak lazım 
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
        ; AX de bulunan sayiyi onluk tabanda hane hane yazdırır. 
        ; CX: haneleri 10a bölerek bulacağız, CX=10 olacak
        ; DX: 32 bölmede işleme dâhil olacak. Soncu etkilemesin diye 0 olmalı 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit bölmede soncu etkilemesin diye 0 olmalı 
        PUSH DX		                        ; haneleri ASCII karakter olarak yığında saklayacağız.
                                                ; Kaç haneyi alacağımızı bilmediğimiz için yığına 0 
                                                ; değeri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; sayı negatif ise AX pozitif yapılır. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; işareti ekrana yazdır. 
        CALL PUTC
        POP AX		                        ; AXi geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = bölüm DX = kalan 
        ADD DX, '0'	                        ; kalan değerini ASCII olarak bul 
        PUSH DX		                        ; yığına sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; bölen 0 kaldı ise sayının işlenmesi bitti demek
        JNE CALC_DIGITS	                        ; işlemi tekrarla 
        
DISP_LOOP:
                                                ; yazılacak tüm haneler yığında. En anlamlı hane üstte 
                                                ; en az anlamlı hane en alta ve onu altında da 
                                                ; sona vardığımızı anlamak için konan 0 değeri var. 
        POP AX		                        ; sırayla değerleri yığından alalım
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII değeri yaz
        JMP DISP_LOOP                          ; işleme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdırır.
        ; BX dizgeye indis olarak kullanılır. Önceki değeri saklanmalıdır. 
        ;------------------------------------------------------------------------
	PUSH BX 
        MOV BX,	AX			        ; Adresi BXe al 
        MOV AL, BYTE PTR [BX]	                ; ALde ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			        ; 0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ; ALdeki karakteri ekrana yazar
        INC BX 				        ; bir sonraki karaktere geç
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			        ; yazdırmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP

CSEG 	ENDS 
	END ANA    
