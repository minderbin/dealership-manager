NAME=controls
$(NAME).exe: $(NAME).obj $(NAME).res
        Link /SUBSYSTEM:WINDOWS /LIBPATH:c:\masm32\lib $(NAME).obj $(NAME).res
$(NAME).res: $(NAME).rc
        rc $(NAME).rc
$(NAME).obj: $(NAME).asm
        ml /c /coff /Cp $(NAME).asm
