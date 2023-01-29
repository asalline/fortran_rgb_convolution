import tkinter as tk
from tkinter import Button, Frame, filedialog
from tkinter.filedialog import askopenfile
from PIL import Image, ImageTk


window = tk.Tk()
window.geometry("1200x600")
window.title('Appi')

my_font1=('Comic Sans MS', 18, 'bold')


l1 = tk.Label(window,text='Select image',width=30,font=my_font1)  
l1.grid(row=1,column=1)
b1 = tk.Button(window, text='Upload File', 
   width=20,command = lambda:upload_file())
b1.grid(row=2,column=1) 

global b2
b2=Button(window,
    text="Avaa",
    command=lambda:toggle_win(),
    border=0,
    borderwidth=1,
    activebackground='#262626')

b2.place(x=5,y=8)


def toggle_win():
    global f1
    f1=Frame(window,width=300,height=500,bg='#12c4c0')
    f1.place(x=0,y=0)
    
    #buttons
    def bttn(x,y,text,bcolor,fcolor,cmd):
     
        def on_entera(e):
            myButton1['background'] = bcolor #ffcc66
            myButton1['foreground']= '#262626'  #000d33

        def on_leavea(e):
            myButton1['background'] = fcolor
            myButton1['foreground']= '#262626'

        myButton1 = Button(f1,text=text,
                       width=42,
                       height=2,
                       fg='#262626',
                       border=0,
                       bg=fcolor,
                       activeforeground='#262626',
                       activebackground=bcolor,            
                        command=cmd)
                      
        myButton1.bind("<Enter>", on_entera)
        myButton1.bind("<Leave>", on_leavea)

        myButton1.place(x=x,y=y)

    bttn(0,80,'H O M E','#0f9d9a','#12c4c0',lambda:click_fun())

    #
    def dele():
        f1.destroy()
        b2=Button(window,
               command=toggle_win,
               border=0,
               bg='#262626',
               activebackground='#262626')
        b2.place(x=5,y=8)

    Button(f1,
    text="sulje",
           border=0,
           command=dele,
           bg='#12c4c0',
           activebackground='#12c4c0').place(x=5,y=10)

def upload_file():
    global img
    f_types = [('Jpg Files', '*.jpg')]
    filename = filedialog.askopenfilename(filetypes=f_types)
    if(filename != None):
        img=Image.open(filename)
        img_resized=img.resize((1200,500)) # new width & height
        img=ImageTk.PhotoImage(img_resized)
        b2 =tk.Button(window,image=img) # using Button 
        b2.grid(row=3,column=1)


def click_fun():
   global pop
   pop = tk.Toplevel(window)
   pop.title("Confirmation")
   pop.geometry("300x150")
   pop.config(bg="white")
   # Create a Label Text
   label = tk.Label(pop, text="Would You like to Proceed?",
   font=('Aerial', 12))
   label.pack(pady=20)
   # Add a Frame
   frame = Frame(pop, bg="gray71")
   frame.pack(pady=10)


   # Add Button for making selection
   button1 = Button(frame, text="Yes", command=lambda:pop.quit(), bg="blue", fg="white")
   button1.grid(row=0, column=1)

window.mainloop()  # Keep the window open


