library(readxl)

Offramp_Zonzeel <- read_excel("D:/salilsharma/SurfDrive/My Documents/Files/Documentation/Lane change/Data/Turbulence.xlsx", 
                         sheet = "Off-ramp-Zonzeel")

library(dplyr)

Offramp <- Offramp_Zonzeel %>%
  mutate(Type = case_when(Len <= 5.60 ~ 'Category 1',
            Len <= 12 ~ 'Category 2',
            TRUE ~ 'Category 3'))


Onramp_Zonzeel <- read_excel("D:/salilsharma/SurfDrive/My Documents/Files/Documentation/Lane change/Data/Turbulence.xlsx", 
                              sheet = "On-ramp-Zonzeel")

Onramp <- Onramp_Zonzeel %>%
  mutate(Type = case_when(Len <= 5.60 ~ 'Category 1',
                          Len <= 12 ~ 'Category 2',
                          TRUE ~ 'Category 3'))
Onramp <- Onramp %>%
  mutate(color_manual = case_when(Len <= 5.60 ~ "#DEEBF7",
                          Len <= 12 ~ "#9ECAE1",
                          TRUE ~ "#4292C6"))
library(ggplot2)

R1<-ggplot(Onramp, aes(x = Pos, fill = Type)) +
  geom_histogram(breaks=seq(-50, 400, by=25),color = "white") +
  theme_classic()+scale_fill_brewer(palette="Blues", name = "")+theme(legend.position="top")+
  labs(title="On-ramp at Zonzeel north", x="Longitudinal position (m)", y = "Number of vehicles")+
  geom_vline(xintercept = 0, linetype="dashed",color = "black")+ ylim(0, 60) +
  geom_vline(xintercept = 340, linetype="dashed", 
             color = "black")

ggplot(Onramp, aes(x=Pos, fill=Type, color=color_manual)) + stat_ecdf(geom = "step",aes(color = color_manual))+
  theme_classic()

ggsave("merge.eps", dpi = 600, width = 8, height = 6, units = "in")

R2<-ggplot(Offramp, aes(x = Pos, fill = Type)) +
  geom_histogram(breaks=seq(-50, 400, by=25), color = "white") +
  theme_classic() +scale_fill_brewer(palette="Blues", name = "")+theme(legend.position="top")+
  labs(title="Off-ramp at Zonzeel south",x="Longitudinal position (m)", y = "Number of vehicles")+
  geom_vline(xintercept = 0, linetype="dashed",color = "black")+
  geom_vline(xintercept = 230, linetype="dashed", 
             color = "black")

ggsave("diverge.eps", dpi = 600, width = 8, height = 6, units = "in")

library("gridExtra")
P1 <- grid.arrange(R1, R2, ncol = 1, nrow = 2)

ggsave("ramps.eps", P1, dpi = 600, width = 8, height = 6, units = "in")

Prin_east <- read_excel("D:/salilsharma/SurfDrive/My Documents/Files/Documentation/Lane change/Data/Turbulence.xlsx", 
                             sheet = "Princeville_east")

Weaving_diverge <- Prin_east %>%
  mutate(Type = case_when(Len <= 5.60 ~ 'Category 1',
                          Len <= 12 ~ 'Category 2',
                          TRUE ~ 'Category 3'))

Prin_west <- read_excel("D:/salilsharma/SurfDrive/My Documents/Files/Documentation/Lane change/Data/Turbulence.xlsx", 
                             sheet = "Princeville_west")

Weaving_merge <- Prin_west %>%
  mutate(Type = case_when(Len <= 5.60 ~ 'Category 1',
                          Len <= 12 ~ 'Category 2',
                          TRUE ~ 'Category 3'))

R3<-ggplot(Weaving_diverge, aes(x = Pos, fill = Type)) +
  geom_histogram(breaks=seq(-100, 1200, by=25),color = "white") +
  theme_classic()+scale_fill_brewer(palette="Blues", name = "")+theme(legend.position="top")+
  labs(title="Diverging behavior at a long weaving section, Princeville East", x="Longitudinal position (m)", y = "Number of vehicles", caption = 'Dashed lines represent bottleneck area')+
  geom_vline(xintercept = 0, linetype="dashed",color = "black")+ ylim(0,30) + scale_x_continuous(breaks=c(0, 200, 400, 600, 800, 1000, 1200)) +
  geom_vline(xintercept = 1000, linetype="dashed", 
             color = "black")

ggsave("lw_diverge.eps", dpi = 600, width = 8, height = 6, units = "in")

R4<-ggplot(Weaving_merge, aes(x = Pos, fill = Type)) +
  geom_histogram(breaks=seq(-100, 1200, by=25),color = "white") +
  theme_classic()+scale_fill_brewer(palette="Blues", name = "")+theme(legend.position="top")+
  labs(title="Merging behavior at a long weaving section, Princeville West", x="Longitudinal position (m)", y = "Number of vehicles", caption = 'Dashed lines represent bottleneck area')+
  geom_vline(xintercept = 0, linetype="dashed",color = "black")+ ylim(0,30) + scale_x_continuous(breaks=c(0, 200, 400, 600, 800, 1000, 1200)) +
  geom_vline(xintercept = 1130, linetype="dashed", 
             color = "black")

ggsave("lw_merge.eps", dpi = 600, width = 8, height = 6, units = "in")

P2 <- grid.arrange(R4, R3, ncol = 1, nrow = 2)

ggsave("long_weaving.eps", P2, dpi = 600, width = 8, height = 6, units = "in")


Kla_north <- read_excel("D:/salilsharma/SurfDrive/My Documents/Files/Documentation/Lane change/Data/Turbulence.xlsx", 
                        sheet = "Kla_north")

Kla_south <- read_excel("D:/salilsharma/SurfDrive/My Documents/Files/Documentation/Lane change/Data/Turbulence.xlsx", 
                        sheet = "Kla_south")

Short_Weaving_diverge <- Kla_south %>%
  mutate(Type = case_when(Len <= 5.60 ~ 'Category 1',
                          Len <= 12 ~ 'Category 2',
                          TRUE ~ 'Category 3'))

Short_Weaving_merge <- Kla_north %>%
  mutate(Type = case_when(Len <= 5.60 ~ 'Category 1',
                          Len <= 12 ~ 'Category 2',
                          TRUE ~ 'Category 3'))

R5<-ggplot(Short_Weaving_diverge, aes(x = Pos, fill = Type)) +
  geom_histogram(breaks=seq(-100,700, by=25),color = "white") +
  theme_classic()+scale_fill_brewer(palette="Blues", name = "")+theme(legend.position="top")+
  labs(title="Diverging behavior at a short weaving section, Klaverpolder south", x="Longitudinal position (m)", y = "Number of vehicles")+
  geom_vline(xintercept = 0, linetype="dashed",color = "black")+ylim(0,100)+ scale_x_continuous(breaks=c(0, 100, 200, 300, 400, 500, 600, 700)) +
  geom_vline(xintercept = 530, linetype="dashed", 
             color = "black")

ggsave("sw_diverge.eps", dpi = 600, width = 8, height = 6, units = "in")

R6<-ggplot(Short_Weaving_merge, aes(x = Pos, fill = Type)) +
  geom_histogram(breaks=seq(-100, 700, by=25),color = "white") +
  theme_classic()+scale_fill_brewer(palette="Blues", name = "")+theme(legend.position="top")+
  labs(title="Merging behavior at a short weaving section, Klaverpolder north", x="Longitudinal position (m)", y = "Number of vehicles")+
  geom_vline(xintercept = 0, linetype="dashed",color = "black")+ylim(0,50)+scale_x_continuous(breaks=c(0, 100, 200, 300, 400, 500, 600, 700)) +
  geom_vline(xintercept = 610, linetype="dashed", 
             color = "black")

ggsave("sw_merge.eps", dpi = 600, width = 8, height = 6, units = "in")

P3 <- grid.arrange(R6, R5, ncol = 1, nrow = 2)

ggsave("short_weaving.eps", P3, dpi = 600, width = 8, height = 6, units = "in")

P11 <- grid.arrange(R1, R6, R4, ncol = 1, nrow = 3)
ggsave("merge_conc.eps", P11, dpi = 600, width = 8, height = 10, units = "in")

P21 <- grid.arrange(R2, R5, R3, ncol = 1, nrow = 3)
ggsave("diverge_conc.eps", P21, dpi = 600, width = 8, height = 10, units = "in")

P111 <- grid.arrange(R1, R6, R4,R2, R5, R3, ncol = 1, nrow = )
ggsave("LC_conc.eps", P111, dpi = 600, width = 8, height = 6, units = "in")
