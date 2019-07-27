library(ggplot2)
library(dplyr)
library(ggmap)
library(stringr)
library(tidyr)
library(shiny)
library(DT)


data_311call = read.csv("xudong_311_prepare.csv")
data_311call_grading = read.csv("xudong_311_prepare_grading.csv")
la_map = get_map(location = "Los Angeles", zoom = 10)

# order the plots
data_311call$CREATEDMONTH = ordered(data_311call$CREATEDMONTH, 
                                    level = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"))
data_311call$SERVICEMONTH = ordered(data_311call$SERVICEMONTH, 
                                    level = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"))
data_311call$RESPONSE_LEVEL = ordered(data_311call$RESPONSE_LEVEL, 
                                      level = c("1-4 days", "5-7 days", "8-14 days", "14 days above"))
data_311call$SERVICE_WDAY = ordered(data_311call$SERVICE_WDAY, 
                                    level = c("Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"))
data_311call$SPA = as.factor(data_311call$SPA)
# order the plots
data_311call_grading$SERVICEMONTH = ordered(data_311call_grading$SERVICEMONTH,
                                    level = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"))
data_311call_grading$SPA = as.factor(data_311call_grading$SPA)
Closed <- data_311call_grading$STATUS == "Closed"

shelters_fun = read.csv("shelters_fun.csv")

#add from Jue
crime=read.csv("crime.csv")
crime$VICTIM.DESCENT = factor(ifelse(crime$VICTIM.DESCENT == "B", "Black",
                                     ifelse(crime$VICTIM.DESCENT == "H", "Hispanic", 
                                            ifelse(crime$VICTIM.DESCENT=="W","White",
                                                   ifelse(crime$VICTIM.DESCENT=="A","Asian","Others")))))

crime$VICTIM.DESCENT=ordered(crime$VICTIM.DESCENT, levels=c("Asian","White","Black","Hispanic","Others"))


############ui
############ui
ui <- fluidPage(tabsetPanel(
    tabPanel("311Call Positivity(month)", 
        titlePanel("LA City Homeless Service Evaluation Tools",  # title panel
                   windowTitle = "311 Call Response Positivity"),
        sidebarPanel(
            helpText("Tools to evaluate the response level over Month Quarter and SPA"),  
          
            radioButtons(inputId = "res_level",
                           label = "Choose a response level to display",
                           choices = list ("1-4 days", "5-7 days", "8-14 days", "14 days above"), 
                           selected = "1-4 days"),
            verbatimTextOutput(outputId = "res_level_note"),
            h5("Below is the bar chart to describe the response level distribution over months"),  
            
            plotOutput(outputId = "map1_bar_side")),
        mainPanel(
          plotOutput(outputId = "map1"),
          plotOutput(outputId = "map1_bar"))
        ),
      tabPanel("311Call Positivity(weekday)", 
            sidebarPanel(
            helpText("Tools to evaluate the response level over Weekdays and SPA"),  
            radioButtons(inputId = "res_level2",
                        label = "Choose a response level to display",
                        choices = list ("1-4 days", "5-7 days", "8-14 days", "14 days above"), 
                        selected = "1-4 days"),
            h5("Below is the bar chart to describe the response level distribution over weekday"),  
            plotOutput(outputId = "map2_bar_side")),
            mainPanel(
            # textOutput(outputId = "selected_var")
            plotOutput(outputId = "map2"),
            plotOutput(outputId = "map2_bar"))
            ),
      tabPanel("311Call Capability(month)",
            sidebarPanel(
            helpText("Tools to evaluate the problem solving ability over Month and SPA"),
            radioButtons(inputId = "status",
                        label = "Choose a call status to display",
                        choices = list ("Closed", "Pending", "Cancelled"),  
                        selected = "Closed"),
            h5("Below is the bar chart to describe different requests' status distribution over weekday"),  
            plotOutput(outputId = "map3_bar_side")),
            mainPanel(
            plotOutput(outputId = "map3"),
            plotOutput(outputId = "map3_bar"))
            ),
      tabPanel("311Call Grading(SPA)",
            sidebarPanel(
              helpText("Select the wight of each variable and get a bar chart of each SPA's monthly service grades"),
              h5("--Weight By Request Status"),
              sliderInput(inputId = "Closed", label = "#Closed requests", min = 0, max = 1, value = .9),
              sliderInput(inputId = "Pending", label = "#Pending requests", min = 0, max = 1, value = .1),
              h5("--Weight By Response Level"),
              sliderInput(inputId = "Fast", label = "#Fast response", min = 0, max = 1, value = .5),
              sliderInput(inputId = "Medium", label = "#Medium requests", min = 0, max = 1,value = .3),
              sliderInput(inputId = "Slow", label = "#Slow requests", min = 0, max = 1, value = .1),
              sliderInput(inputId = "VerySlow", label = "#Very Slow requests", min = 0, max = 1, value = .1)
            ),
            mainPanel(
              plotOutput(outputId = "gradingBar"), 
              dataTableOutput(outputId = "gradingTable"))
            ),
    #add tabPanel for Sheng
    tabPanel("Shelters' Distribution",
             
             # Application title
             titlePanel("Shelter distribution"),
             
             # Sidebar with a slider input for number of bins 
             sidebarLayout(      
               sidebarPanel("Conditions",
                            checkboxGroupInput("show_funs", "Functions",
                                               names(shelters_fun)[9:27], 
                                               selected = NULL),
                            checkboxGroupInput("show_weekdays","Weekdays",
                                               names(shelters_fun)[28:34],
                                               selected = NULL),
                            checkboxGroupInput("show_restrictions","Restrictions to show",
                                               names(shelters_fun)[35:39],
                                               selected = NULL)),
               mainPanel(
                 tabsetPanel(
                   id = 'dataset',
                   tabPanel("Shelters' Information", DT::dataTableOutput("table1")),
                   tabPanel("Map", 
                            plotOutput(outputId = "plot1"),
                            plotOutput(outputId = "plot2"))
                 )
               )   
             ) 
             ),
    #add from Jue
    tabPanel("Crime Type",
             
             sidebarPanel(
               helpText("Crime Types in Los Angeles"),
               checkboxGroupInput(inputId = "type",
                                  label = "Choose a crime type to display",
                                  choices = list ("AGGRAVATED ASSAULT", "SIMPLE ASSAULT", "ROBBERY","THEFT","RAPE","OTHERS"), 
                                  selected = c("AGGRAVATED ASSAULT","SIMPLE ASSAULT", "ROBBERY","THEFT","RAPE"))),
             mainPanel(
               verticalLayout(
                 h5("Crime Type in LA", align = "center"),
                 plotOutput(outputId = "crime_type"),
                 splitLayout(
                   plotOutput(outputId = "type_premise"),
                   plotOutput(outputId = "type_weapon")),
                 splitLayout(
                   plotOutput(outputId = "type_month"),
                   plotOutput(outputId = "type_hour")),
                 splitLayout(
                   plotOutput(outputId = "age_type"),
                   plotOutput(outputId = "gender_type"),
                   plotOutput(outputId = "ethnicity_type"))
               ))
    ),
    
    tabPanel("Crime Premise",
             
             sidebarPanel(
               helpText("Crime Premise in Los Angeles"),
               checkboxGroupInput(inputId = "premise",
                                  label = "Choose a crime premise to display",
                                  choices = list ("STREET", "SIDEWALK", "PARKING LOT","PARK/PLAYGROUND","DWELLING","OTHERS"), 
                                  selected = "STREET")),
             mainPanel(
               verticalLayout(
                 h5("Crime Premise in LA", align = "center"),
                 plotOutput(outputId = "crime_premise"),
                 splitLayout(
                   plotOutput(outputId = "premise_month"),
                   plotOutput(outputId = "premise_hour")),
                 splitLayout(
                   plotOutput(outputId = "age_premise"),
                   plotOutput(outputId = "gender_premise"),
                   plotOutput(outputId = "ethnicity_premise"))
               ))
    ),
    
    tabPanel("Crime Weapon",
             
             sidebarPanel(
               helpText("Weapon used in Crime"),
               checkboxGroupInput(inputId = "weapon",
                                  label = "Choose a kind of weapon to display",
                                  choices = list ("STRONG-ARM", "KNIFE", "STICK","GUN","PIPE","OTHERS"), 
                                  selected = "STRONG-ARM")),
             mainPanel(
               verticalLayout(
                 h5("Weapon used in Crime", align = "center"),
                 plotOutput(outputId = "crime_weapon"),
                 splitLayout(
                   plotOutput(outputId = "weapon_month"),
                   plotOutput(outputId = "weapon_hour")),
                 splitLayout(
                   plotOutput(outputId = "age_weapon"),
                   plotOutput(outputId = "gender_weapon"),
                   plotOutput(outputId = "ethnicity_weapon"))
               ))
             
    ),
    tabPanel("Crime vs. Shelters",
             sidebarPanel(
               helpText("Crime Types in Los Angeles"),
               checkboxGroupInput(inputId = "type1",
                                  label = "Choose a crime type to display",
                                  choices = list ("AGGRAVATED ASSAULT", "SIMPLE ASSAULT", "ROBBERY","THEFT","RAPE","OTHERS"), 
                                  selected = "AGGRAVATED ASSAULT"),
               checkboxGroupInput("show_funs1", "Functions",
                                  names(shelters_fun)[9:27], 
                                  selected = NULL)),
             mainPanel(plotOutput(outputId = "crime_shelters"))
             )
    
))


###########server
###########server
###########server
server <- function(input, output) {
    #1 reactive res_level  #1 reactive res_level
    data_311call_selected_res_level = reactive({
        data_311call %>% filter(RESPONSE_LEVEL %in% input$res_level)})
    #add operation from Sheng
    shelters_fun = read.csv("shelters_fun.csv")
    shelters_fun2= shelters_fun
    #1 map
    output$map1 <- renderPlot({
        ggmap(la_map) +
            stat_density2d(data = data_311call_selected_res_level(), 
                         aes(x = LONGITUDE, y = LATITUDE, fill = RESPONSE_LEVEL,
                             alpha = ..level..),
                         geom = "polygon") +
            theme_void()+
            labs(x = "", y = "", 
                 title = paste("Response Level (",input$res_level, ") Distribution by Month", collapse = ""))+
            theme(legend.position = "none") +
            theme(plot.title = element_text(size = 18, hjust = .5))+
            facet_wrap(~SERVICEMONTH)
        })
    #1 bar chart over quarter and SPA
    output$map1_bar <- renderPlot({
        ggplot(data = data_311call_selected_res_level(), 
             aes(x = SERVICEMONTH, fill = SPA)) +
        geom_bar(position = "dodge")+
        geom_label(stat = "count", aes(label = ..count.., y = ..count..))+
        theme_bw()+
        theme(plot.title = element_text(size = 18, hjust = .5))+
        labs(x = "Month", y = "Service Counts", 
             title = paste("Response Level  (",input$res_level, ")  Counts by Month & SPA", collapse = ""))+
        theme(legend.position = "bottom")
    })
    #1 side bar chart over month and res_level (isolate)
    output$map1_bar_side <- renderPlot({
      ggplot(data = data_311call, #[data_311call_selected()$SPA %in% c(4,5,6),], 
             aes(x = SERVICEMONTH, fill = RESPONSE_LEVEL)) +
        geom_bar(position = "dodge")+
#        geom_label(stat = "count", aes(label = ..count.., y = ..count..))+
        theme_bw()+
        labs(x = "Month", y = "Counts", 
             title = paste("Response Level Counts\nby month", collapse = ""))+
        theme(legend.position="bottom", legend.title = element_blank())
    })
    #1 note
    output$res_level_note <- renderText({
        paste("Notes of response level:", "Fast (1-4 days)", "Medium (5-7 days)",
              "Slow (8-14 days)", "Very Slow (14 days above)",sep="\n")
    })
    
    #2 reactive res_level
    data_311call_selected2_res_level = reactive({
        data_311call %>% filter(RESPONSE_LEVEL %in% input$res_level2)        
    })
    #2 map
    output$map2 <- renderPlot({
        ggmap(la_map) +
          stat_density2d(data = data_311call_selected2_res_level(), 
                         aes(x = LONGITUDE, y = LATITUDE,
                             fill = RESPONSE_LEVEL,
                             alpha = ..level..),
                         geom = "polygon") +
          theme_void()+
          theme(plot.title = element_text(size = 18, hjust = .5))+    
          labs(x = "", y = "", 
               title = paste("Response Level Distribution by Weekday", collapse = ""))+
          theme(legend.position = "bottom")  +
        facet_wrap(~SERVICE_WDAY)
    })
    #2 map_bar
    output$map2_bar <- renderPlot({
        ggplot(data = data_311call_selected2_res_level(), 
             aes(x = SERVICE_WDAY, fill = SPA)) +
        geom_bar(position = "dodge")+
        geom_label(stat = "count", aes(label = ..count.., y = ..count..))+
        theme_bw()+
        theme(plot.title = element_text(size = 18, hjust = .5))+
        labs(x = "Weekday", y = "Service Counts", 
             title = paste("Response Level  (",input$res_level2, ")  Counts by Weekday & SPA", collapse = ""))+
        theme(legend.position = "bottom")
    })
    #2 bar_side: bar chart over month and res_level (isolate)
    output$map2_bar_side <- renderPlot({
      ggplot(data = data_311call, 
             aes(x = SERVICE_WDAY, fill = RESPONSE_LEVEL)) +
        geom_bar(position = "dodge")+ 
#        geom_label(stat = "count", aes(label = ..count.., y = ..count..))+
        theme_bw()+
        labs(x = "Week Day", y = "Service Counts", 
             title = paste("Response Level Counts\nby weekday", collapse = ""))+
        theme(legend.position="bottom", legend.title = element_blank())
    })
    
    ##3 reactive_status  ##3 reactive_status
    data_311call_selected_status = reactive({
        data_311call %>% filter(STATUS %in% input$status)})
    #3 map
    output$map3 <- renderPlot({
        ggmap(la_map) +
            stat_density2d(data = data_311call_selected_status(), 
                           aes(x = LONGITUDE, y = LATITUDE,fill = CREATEDMONTH,
                               alpha = ..level..), geom = "polygon") +
            facet_wrap(~CREATEDMONTH)+
            theme(legend.position = "none")+
            theme(plot.title = element_text(size = 18, hjust = .5))+
            labs(x = "", y = "", 
                 title = paste(input$status," Requests Distribution", collapse = ""))+
            theme_void()
    })
    #3 map_bar
    output$map3_bar <- renderPlot({
        ggplot(data_311call_selected_status(), aes(x = CREATEDMONTH, fill = SPA)) +
            geom_bar(position = "dodge")+
            geom_label(stat = "count", aes(label = ..count.., y = ..count..))+
            theme_bw()+
            theme(plot.title = element_text(size = 18, hjust = .5),
                  legend.position = "bottom")+
            labs(y = "counts",
                 title = paste(input$status," Requests Counts by Month & SPA", collapse = ""))
    })
    #3 map_bar_side
    output$map3_bar_side <- renderPlot({
        ggplot(data_311call, aes(x = CREATEDMONTH, fill = STATUS)) +
            geom_bar(position = "dodge")+
            theme_bw()+
            theme(legend.position = "bottom")+
            labs(y = "counts",
                 title = paste("Different Request Status Counts\nby Month", collapse = ""))
    })
    
    
    #4 reactive_grading #4 reactive_grading
    data_311call_grading2 = reactive({
        data_311call_grading[Closed,]$grading = 
            data_311call_grading[Closed,]$Fast * input$Fast * input$Closed + 
            data_311call_grading[Closed,]$Medium * input$Medium * input$Closed  +
            data_311call_grading[Closed,]$Slow * input$Slow * input$Closed  +
            data_311call_grading[Closed,]$VerySlow * input$VerySlow * input$Closed
        
        data_311call_grading[!Closed,]$grading = 
            data_311call_grading[!Closed,]$Fast * input$Fast * input$Pending + 
            data_311call_grading[!Closed,]$Medium * input$Medium * input$Pending  +
            data_311call_grading[!Closed,]$Slow * input$Slow * input$Pending  +
            data_311call_grading[!Closed,]$VerySlow * input$VerySlow * input$Pending
        
        data_311call_grading %>%
            group_by(SPA, SERVICEMONTH,totpeople)%>%
            summarise(tot_grading_index = round(sum(grading)/sum(totpeople)*100,3))
    })
    #4 grading bar
    output$gradingBar <- renderPlot({
      ggplot(data_311call_grading2(), aes(x = SERVICEMONTH, y = tot_grading_index, 
                                       fill = SPA)) +
        geom_bar(stat = "identity", position = "dodge") +
        #geom_label(stat = "count", aes(label = ..count.., y = ..count..))
        geom_label(aes(label = tot_grading_index, fill = SPA)) +
        theme_bw()+
        theme(plot.title = element_text(size = 18, hjust = .5),
              legend.position = "bottom")+
        labs(title = "311 Call Service Quality Grading Tool",
             subtitle = "Index = [Closed%(Fast% + Medium% + Slow% + VerySlow%)\n            
                   Penging%(Fast% + Medium% + Slow% + VerySlow%)]/Total homelss",
             y = "Grading Index") +
        theme(plot.subtitle = element_text(size = 12,colour="steelblue",hjust = .9)) 
    })
    #4 table
    output$gradingTable <- renderDataTable({
      DT::datatable(data_311call_grading2()%>%
                        select(-totpeople) %>%
                        arrange(desc(tot_grading_index)))
    })
    
    #add output from Sheng
    shelters_plot = reactive({
      if(is.null(input$show_weekdays)){
        shelters_weekdays = shelters_fun2[2]
      }
      else{
        shelters_weekdays = shelters_fun2 %>% 
          select(2,input$show_weekdays)
        shelters_weekdays[shelters_weekdays == 0] =NA
        shelters_weekdays = na.omit(shelters_weekdays)[1]
      }
      
      
      if(is.null(input$show_funs)){
        shelters_fun3 = shelters_fun2[2]
      }
      else{
        shelters_fun3 = shelters_fun2 %>% 
          select(2,input$show_funs)
        shelters_fun3[shelters_fun3 == 0] =NA
        shelters_fun3 = na.omit(shelters_fun3)[1]
      }
      
      if(is.null(input$show_restrictions)){
        shelters_restrictions = shelters_fun2[2]
      }
      else{
        shelters_restrictions = shelters_fun2 %>% 
          select(2,input$show_restrictions)
        shelters_restrictions[shelters_restrictions == 0] =NA
        shelters_restrictions = na.omit(shelters_restrictions)[1]
      }
      
      weekdays_fun = plyr::join(shelters_weekdays,
                                shelters_fun3, 
                                by = "shelters.NAME",
                                type = "inner")
      res_weekdays_fun = plyr::join(shelters_restrictions,
                                weekdays_fun, 
                                by = "shelters.NAME",
                                type = "inner")
      shelters_plot = plyr::join(res_weekdays_fun,
                                 shelters_fun2,
                                 by = "shelters.NAME")
      colnames(shelters_plot)[c(1,5,6,7,8)]= c("Shelter'name",
                                               "City",
                                               "Org",
                                               "Address",
                                               "Phones")
      shelters_plot
      
    })
    output$plot1 = renderPlot(
      {ggmap(la_map) +
          geom_point(data = shelters_plot(),
                     aes(x=shelters.LONGITUDE,
                         y=shelters.LATITUDE,
                         color = City),
                     size =3)+
          xlab("")+
          ylab("")+
          ggtitle("Shelters Distribution")+
          theme(legend.position = "bottom")
      }
    )
    
    output$table1 = renderDataTable(
      {
        DT::datatable(shelters_plot()[,c(1,5,6,7,8)])
      }
    )
    output$plot2 = renderPlot(
      {
        grouped = shelters_plot() %>% 
          group_by(shelters.SPA) %>% 
          summarise(count = n())
        grouped = na.omit(grouped)
        ggplot(data = grouped,
               aes(x = as.factor(shelters.SPA),
                   y = count,
                   fill = as.factor(shelters.SPA)))+
          geom_bar(stat = "identity")+
          xlab("Number of Shelters")+
          ylab("SPA")+
          ggtitle("Shalters count by SPA")+
          geom_text(aes(label = count),   # xudong help!
                    position = position_stack(vjust = 0.8)) 
      }
    )
    
#add from Jue    
    output$crime_type = renderPlot({
      
      crime_type_shiny = reactive({
        crime %>%
          filter(crime_type %in% input$type)})
      
      ggmap(la_map) +
        geom_point(data=crime_type_shiny(),
                   aes(x=LONGITUDE,
                       y=LATITUDE,color=crime_type))+
        theme(legend.position = "none")+
        theme_void()
      
    })
    
    output$type_premise = renderPlot ({
      crime_type_shiny = reactive({
        crime_type_shiny = crime %>%
          filter(crime_type %in% input$type)})
      
      ggplot(crime_type_shiny(),aes(x=crime_type,fill=crime_premise))+
        geom_bar(stat="count")+
        xlab("Crime Type")+
        theme_bw()+
        theme(legend.title = element_blank())+
        ggtitle("Crime Type and Crime Premise")
      
    })
    
    
    output$type_weapon = renderPlot ({
      crime_type_shiny = reactive({
        crime_type_shiny = crime %>%
          filter(crime_type %in% input$type)})
      
      ggplot(crime_type_shiny(),aes(x=crime_type,fill=crime_weapon))+
        geom_bar(stat="count")+
        xlab("Crime Type")+
        theme_bw()+
        theme(legend.title = element_blank())+
        ggtitle("Crime Type and Weapon")
      
    })
    
    
    
    output$type_month = renderPlot ({
      crime_type_shiny = reactive({
        crime_type_shiny = crime %>%
          filter(crime_type %in% input$type)})
      
      ggplot(crime_type_shiny(),aes(as.factor(newdate)))+
        geom_histogram(stat="count",aes(fill=crime_type))+
        geom_line(stat="count",group=1,adjust=5,color="#D55E00")+
        ggtitle("Month Distribution of Crime Occurred")+
        xlab("Month")+
        theme_bw()
      
    })
    
    output$type_hour = renderPlot ({
      crime_type_shiny = reactive({
        crime_type_shiny = crime %>%
          filter(crime_type %in% input$type)})
      
      ggplot(crime_type_shiny(),aes(as.factor(H)))+
        geom_histogram(stat="count",aes(fill=crime_type))+
        geom_line(stat="count",group=1,adjust=5,color="#D55E00")+
        ggtitle("Hour Distribution of Crime Occurred")+
        xlab("Hour")+
        theme_bw()
      
    })
    
    output$age_type = renderPlot ({
      crime_type_shiny = reactive({
        crime_type_shiny = crime %>%
          filter(crime_type %in% input$type)})
      
      ggplot(crime_type_shiny(),aes(x=VICTIM.AGE))+
        geom_histogram(aes(y=..density..), fill="#009E73",binwidth=3)+
        geom_density(aes(y=..density..),color="#D55E00")+
        ggtitle("Age Distribution of the Victims")+
        xlab("Age of Victim")+
        ylab("")+
        theme_bw()
      
    })
    
    output$gender_type = renderPlot ({
      crime_type_shiny = reactive({
        crime_type_shiny = crime %>%
          filter(crime_type %in% input$type)})
      
      ggplot(crime_type_shiny(),aes(x=VICTIM.SEX,fill=VICTIM.SEX))+
        geom_histogram(stat="count")+
        xlab("Gender")+
        ggtitle("Gender of the Victims")+
        theme_bw()+
        theme(legend.position="none")
      
    })
    
    output$ethnicity_type = renderPlot ({
      crime_type_shiny = reactive({
        crime_type_shiny = crime %>%
          filter(crime_type %in% input$type)})
      
      
      ggplot(crime_type_shiny(),aes(x=VICTIM.DESCENT))+
        geom_histogram(stat="count",fill="#009E73")+
        xlab("Ethnicity of the Victims")+
        ggtitle("Ethnicity Distribution of the Victims")+
        theme_bw()
      
    })
    
    output$crime_premise = renderPlot ({
      crime_premise_shiny = reactive({
        crime_premise_shiny = crime %>%
          filter(crime_premise %in% input$premise)})
      
      ggmap(la_map) +
        geom_point(data=crime_premise_shiny(),
                   aes(x=LONGITUDE,
                       y=LATITUDE,color=crime_premise))+
        theme(legend.position = "none")+
        theme_void()
      
    })
    
    output$premise_month = renderPlot ({
      crime_premise_shiny = reactive({
        crime_premise_shiny = crime %>%
          filter(crime_premise %in% input$premise)})
      
      ggplot(crime_premise_shiny(),aes(as.factor(newdate)))+
        geom_histogram(stat="count",aes(fill=crime_premise))+
        geom_line(stat="count",group=1,adjust=5,color="#D55E00")+
        ggtitle("Month Distribution of Crime Occurred")+
        xlab("Month")+
        theme_bw()
      
    })
    
    output$premise_hour = renderPlot ({
      crime_premise_shiny = reactive({
        crime_premise_shiny = crime %>%
          filter(crime_premise %in% input$premise)})
      
      ggplot(crime_premise_shiny(),aes(as.factor(H)))+
        geom_histogram(stat="count",aes(fill=crime_premise))+
        geom_line(stat="count",group=1,adjust=5,color="#D55E00")+
        ggtitle("Hour Distribution of Crime Occurred")+
        xlab("Hour")+
        theme_bw()
      
    })
    
    output$age_premise = renderPlot ({
      crime_premise_shiny = reactive({
        crime_premise_shiny = crime %>%
          filter(crime_premise %in% input$premise)})
      
      ggplot(crime_premise_shiny(),aes(x=VICTIM.AGE))+
        geom_histogram(aes(y=..density..), fill="#009E73",binwidth=3)+
        geom_density(aes(y=..density..),color="#D55E00")+
        ggtitle("Age Distribution of the Victims")+
        xlab("Age of Victim")+
        ylab("")+
        theme_bw()
      
    })
    
    output$gender_premise = renderPlot ({
      crime_premise_shiny = reactive({
        crime_premise_shiny = crime %>%
          filter(crime_premise %in% input$premise)})
      
      ggplot(crime_premise_shiny(),aes(x=VICTIM.SEX,fill=VICTIM.SEX))+
        geom_histogram(stat="count")+
        xlab("Gender")+
        ggtitle("Gender of the Victims")+
        theme_bw()+
        theme(legend.position="none")
      
      
    })
    
    output$ethnicity_premise = renderPlot ({
      crime_premise_shiny = reactive({
        crime_premise_shiny = crime %>%
          filter(crime_premise %in% input$premise)})
      
      
      ggplot(crime_premise_shiny(),aes(x=VICTIM.DESCENT))+
        geom_histogram(stat="count",fill="#009E73")+
        xlab("Ethnicity of the Victims")+
        ggtitle("Ethnicity Distribution of the Victims")+
        theme(legend.position="none")+
        theme_bw()
      
    })
    
    output$crime_weapon = renderPlot ({
      crime_weapon_shiny = reactive({
        crime_weapon_shiny = crime %>%
          filter(crime_weapon %in% input$weapon)})
      
      ggmap(la_map) +
        geom_point(data=crime_weapon_shiny(),
                   aes(x=LONGITUDE,
                       y=LATITUDE,color=crime_weapon))+
        theme(legend.position = "none")+
        theme_void()
      
    })
    
    output$weapon_month = renderPlot ({
      crime_weapon_shiny = reactive({
        crime_weapon_shiny = crime %>%
          filter(crime_weapon %in% input$weapon)})
      
      ggplot(crime_weapon_shiny(),aes(as.factor(newdate)))+
        geom_histogram(stat="count",aes(fill=crime_weapon))+
        geom_line(stat="count",group=1,adjust=5,color="#D55E00")+
        ggtitle("Month Distribution of Crime Occurred")+
        xlab("Month")+
        theme_bw()
      
    })
    
    output$weapon_hour = renderPlot ({
      crime_weapon_shiny = reactive({
        crime_weapon_shiny = crime %>%
          filter(crime_weapon %in% input$weapon)})
      
      ggplot(crime_weapon_shiny(),aes(as.factor(H)))+
        geom_histogram(stat="count",aes(fill=crime_weapon))+
        geom_line(stat="count",group=1,adjust=5,color="#D55E00")+
        ggtitle("Hour Distribution of Crime Occurred")+
        xlab("Hour")+
        theme_bw()
      
    })
    
    output$age_weapon = renderPlot ({
      crime_weapon_shiny = reactive({
        crime_weapon_shiny = crime %>%
          filter(crime_weapon %in% input$weapon)})
      
      ggplot(crime_weapon_shiny(),aes(x=VICTIM.AGE))+
        geom_histogram(aes(y=..density..), fill="#009E73",binwidth=3)+
        geom_density(aes(y=..density..),color="#D55E00")+
        ggtitle("Age Distribution of the Victims")+
        xlab("Age of Victim")+
        ylab("")+
        theme_bw()
      
    })
    
    output$gender_weapon = renderPlot ({
      crime_weapon_shiny = reactive({
        crime_weapon_shiny = crime %>%
          filter(crime_weapon %in% input$weapon)})
      
      ggplot(crime_weapon_shiny(),aes(x=VICTIM.SEX,fill=VICTIM.SEX))+
        geom_histogram(stat="count")+
        xlab("Gender")+
        ggtitle("Gender of the Victims")+
        theme_bw()+
        theme(legend.position="none")
      
    })
    
    output$ethnicity_weapon = renderPlot ({
      crime_weapon_shiny = reactive({
        crime_weapon_shiny = crime %>%
          filter(crime_weapon %in% input$weapon)})
      
      
      ggplot(crime_weapon_shiny(),aes(x=VICTIM.DESCENT))+
        geom_histogram(stat="count",fill="#009E73")+
        xlab("Ethnicity of the Victims")+
        ggtitle("Ethnicity Distribution of the Victims")+
        theme_bw()
      
    })
    output$crime_shelters = renderPlot({
      
      crime_shelters_plot = reactive({
        crime %>%
          filter(crime_type %in% input$type1)})
      
      shelters_crime_plot = reactive({
        if(is.null(input$show_funs1)){
          shelters_fun3 = shelters_fun2[2]
        }
        else{
          shelters_fun3 = shelters_fun2 %>% 
            select(2,input$show_funs1)
          shelters_fun3[shelters_fun3 == 0] =NA
          shelters_fun3 = na.omit(shelters_fun3)[1]
        }
        shelters_plot = plyr::join(shelters_fun3,
                                   shelters_fun2,
                                   by = "shelters.NAME",
                                   type = "inner")
        shelters_plot
        
      })
      
      
      ggmap(la_map) +
        stat_density2d(data = crime_shelters_plot(), 
                       aes(x = LONGITUDE, 
                           y = LATITUDE,
                           fill = crime_type,
                           alpha = ..level..),
                       geom = "polygon") +
        theme_void()+
        theme(plot.title = element_text(size = 18, hjust = .5))+    
        theme(legend.position = "bottom")+
        geom_point(data = shelters_crime_plot(),
                   aes(x=shelters.LONGITUDE,
                       y=shelters.LATITUDE,
                       color = shelters.CITY),
                   size =3)+
        ggtitle("Shelters Distribution")+
        theme(legend.position = "bottom")
      })
    
}

# run
shinyApp(ui = ui, server =server)