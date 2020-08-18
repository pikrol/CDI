#install.packages(mirtCAT)
library(mirtCAT)
options(stringsAsFactors = FALSE)


### Create simple non-adaptive interface ###

#Load items from csv file
wd.datapath = paste0(getwd(),"/data")
wd.init = getwd()
setwd(wd.datapath)
items = read.csv("items.csv", encoding = "UTF-8", na.strings=c("","NA"))
setwd(wd.init)

#Prepare questions
instr <- "Zaznacz wszystkie słowa, które mówi Twoje dziecko."
createProgressBar <- function(percent){
  return(div(class="progress", div(class="progress-bar", style=paste0("width: ",percent), percent)))
}
createQuestion <- function(title, percent){
  return(div(createProgressBar(percent), instr, br(), br(), strong(title)))
}

questions <- sapply(
  list(
    createQuestion("Odgłosy i wykrzykniki", "0%"),
    createQuestion("Zwierzęta - prawdziwe lub zabawkowe", "33%"),
    createQuestion("Pojazdy - prawdziwe lub zabawkowe", "67%")
  ),
  as.character
)

df <- data.frame(Question = questions, Option = t(items), Type = "checkbox")


#Modify GUI
title <- "Inwentarz Rozwoju Mowy i Komunikacji"
authors <- ""
instructions <- c("Aby przejść dalej naciśnij przycisk poniżej.", "Dalej")
firstpage <- list(
  h2("Witaj!"),
  h5("Kwestionariusz ten jest polską adaptacją amerykańskiego inwentarza do badania rozwoju mowy dzieci (MacArthur-Bates Communicative Development Inventory). Metoda ta opiera się na wiedzy rodziców na temat rozwoju językowego własnych dzieci. Aby dobrze wypełnić kwestionariusz, należy przeczytać pytania i przez parę dni uważniej przysłuchiwać się temu, co dziecko mówi. Można też zanotować niektóre wypowiedzi dziecka, aby później móc je wpisać do tabel D i E na ostatniej stronie. Dziecka nie należy przepytywać ani prosić o powtarzanie poszczególnych wyrazów czy zwrotów, ani też „uczyć słówek”. Wystarczy, gdy rodzice odpowiedzą na pytania według własnej wiedzy o dziecku."),
  h5("Dzieci rozumieją znacznie więcej słów niż same używają w mowie. Ten kwestionariusz dotyczy tylko tych słów, które Państwa dziecko spontanicznie mówi. Nie chodzi o to, co dziecko jest w stanie powtórzyć, ale o słowa, których samo z siebie używa. Proszę uważnie przeczytać listę wyrazów i zaznaczyć te z nich, które słyszeli Państwo od swego dziecka. Jeżeli dziecko używa nieco innej formy, np. mówi piesek, a nie pies, proszę mimo to zaznaczyć plus przy słowie pies. Tak samo należy postąpić, jeśli dziecko wymawia jakieś słowo inaczej (np. lybka zamiast rybka lub wiójka zamiast wiewiórka); można też wpisać brzmienie wyrazu w takiej formie, w jakiej dziecko go używa. Czasami dzieci wymyślają własne wyrazy, np. dzi zamiast piłka. Także taką formę należy potraktować jako wyraz i wstawić plus przy słowie „piłka”, dodatkowo wpisując „dzi”. Podobnie, jeśli w rodzinie funkcjonuje inne określenie niż podane w kwestionariuszu, proszę zaznaczyć odpowiednią pozycję i dopisać właściwe określenie. Wszelkie wątpliwości można dopisać na kwestionariuszu."),
  h5("UWAGA: Kwestionariusz przeznaczony jest dla dzieci w różnym wieku. Proszę się nie martwić, jeśli Państwa dziecko jeszcze nie używa wszystkich słów i gestów, o które pytamy!")
)
lastpage <- function(person){
  return(list(h5("Dziękujemy za wypełnienie inwentarza!")))
}
css <- "

  h5 {
  text-align: justify;
  }
  
"

shinyGUI_list <- list(title = title, authors = authors, instructions = instructions, firstpage = firstpage, lastpage = lastpage, css = css, theme = 'flatly', forced_choice = FALSE)


## Run the mirtCAT web interface and store results
results <- mirtCAT(df = df, shinyGUI = shinyGUI_list)
print(results)
summary(results)