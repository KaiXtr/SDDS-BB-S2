# SDDS-BB-S2

Baseado no worm de Windows 2000 ILOVEYOU, criado por Onel de Guzman e programado inteiramente em Visual Basic Script. Minha modificação consiste em um worm que, além de criar e exibir uma página web, duplica os arquivos do sistema, preservando seu conteúdo. Em todas as situações, o worm exibe mensagem de amor. Embora inofensivo, o worm é potencialmente prejudicial e com a possibilidade de estourar o armazenamento do dispositivo de forma não intencionada a cada nova inicialização do sistema.
![sdds-bb-s2](https://github.com/user-attachments/assets/f2c4a535-6821-47a1-bfc8-6d7a13290787)

![Captura de tela de 2024-07-16 23-23-20](https://github.com/user-attachments/assets/7c6f5c33-1e65-45c5-a323-8b7152f34b3d)

### Sobre o ILOVEYOU

O worm original, conhecido popularmente como ILOVEYOU ou Love Bug, foi criado por Onel de Guzman e detectado pela primeira vez no ano de 2000 nos sistemas Windows 2000, que sofriam de diversas vulnerabilidades que permitiam a execução de scripts VBS diretamente de um cliente de email e que escondiam a extensão destes arquivos do usuário final.

Criado como trabalho de conclusão de curso da faculdade de computação de Guzman, que posteriormente a largou após a rejeição do seu TCC, o worm não é de todo muito competente, possuindo algumas falhas e sendo feito em uma linguagem de programação não muito comum para ataques de baixo nível. Contudo, é inegável o grande impacto que as linhas de código que se seguem causaram ao redor do mundo, pois nem mesmo Guzman imaginou que seu worm causaria tanto estrago para fora das redondezas das filipinas.

---

## ILOVEYOU

> **ILOVEYOU**, sometimes referred to as **Love Bug** or **Love Letter**, was a
> [computer worm](https://en.wikipedia.org/wiki/Computer_worm) that attacked
> tens of millions of [Windows](https://en.wikipedia.org/wiki/Microsoft_Windows)
> personal computers on and after 5 May 2000 local time in the
> [Philippines](https://en.wikipedia.org/wiki/Philippines) when it started
> spreading as an email message with the subject line "ILOVEYOU" and the
> attachment "LOVE-LETTER-FOR-YOU.txt.vbs".
>
> — Wikipedia, [ILOVEYOU](https://en.wikipedia.org/wiki/ILOVEYOU)

This is a formatted version of the **ILOVEYOU** worm also known as **Love
Letter**. It includes comments which explains the routines that are used by the
worm to infect and spread itself.

## How it works

The worm is distributed primarily through email, most prominently [Microsoft
Outlook](https://en.wikipedia.org/wiki/Microsoft_Outlook) at the time. It does
so by sending an email to each of the victim's contacts, listed in their
[Address Book](https://en.wikipedia.org/wiki/Windows_Address_Book).

When executed, it infects different files in the system by writing itself to
document files, MP3s/MP2s, JPEG, and other Visual Basic scripts and changing
their extension to `.vbs`, making them executable.

It also makes it so, after having executed the script the first time, will
execute on each startup of the computer, making it very difficult to stop.

It relies on the fact that Windows will automatically execute any Visual
Basic Script files, when opened from the file explorer or from Outlook, making
it trivial for a victim to accidentally execute it.

## Disclaimer

**This program and its source files are only uploaded for educational purposes.
Do not execute this program if you do not know what it does and what the risks
are.**

## Credits

The original source code was obtained from
[Cexx.org](http://www.cexx.org/loveletter.htm) and formatted and commented by
me.
