%%MUESTRAS TOMADAS DE PHYSIONET https://physionet.org/content/eegmmidb/1.0.0
%%Realizamos descomposicion de Wavalet Tree para tomar muestras
%%comprendidas entre 0-30 HZ
%cargamos ejemplo de toma de datos
dir='C:\Users\alvaro\Desktop\UNIVERSIDAD\TFG\MuestrasPhysionet\files\';
c='\';
d='.edf';
load('PassBand.mat');
load('Alfa.mat');
load('Beta.mat');
load('Theta.mat');
load('Delta.mat');
for sujetos=1:109

for sesionaux=2:7

    if sujetos<10
        a='S00';
    elseif (9<sujetos)&&(sujetos<100)
        a='S0';
    else
        a='S';
    end
    sesion= sesionaux*2;
    if sesion<10
        b='R0';
    else
        b='R';
    end
suj=string(sujetos);
ses = string(sesion);
filename= strcat(dir,a,suj,c,a,suj,b,ses,d);

[data, anotaciones]=edfread(filename);

%Extraemos los canales que nos interesan.
CanalCz= data.Cz__{1,1};
CanalCz=transpose(CanalCz);
CanalC3=data.C3__{1,1};
CanalC3=transpose(CanalC3);
CanalC4=data.C4__{1,1};
CanalC4=transpose(CanalC4);
long= length(data.Cz__);
for x=2:long
auxC3= data.C3__{x,1};
auxCz= data.Cz__{x,1};
auxC4= data.C4__{x,1};
auxC3= transpose(auxC3);
auxCz= transpose(auxCz);
auxC4= transpose(auxC4);
CanalC4= [CanalC4 auxC4];
CanalC3= [CanalC3 auxC3];
CanalCz= [CanalCz auxCz];
eventostime= anotaciones.Onset;
eventoslabel= anotaciones.Annotations;
end
%analizamos los 30 eventos observando 4 segundos de cada evento

%%Evento1
for x=1:30
event=seconds(eventostime(x));
tipoevento=eventoslabel(x);
c3aux= CanalC3(1,160*event+1+80:160*(event+2)+80);
c4aux= CanalC4(1,160*event+1+80:160*(event+2)+80);
czaux= CanalCz(1,160*event+1+80:160*(event+2)+80);
%examen banda de 5-30 hz
c3band=filter(PassBand,c3aux);
czband=filter(PassBand,czaux);
c4band=filter(PassBand,c4aux);
[cc3 ,lc3]= wavedec(c3band,1,'db2');
[ccz ,lcz]= wavedec(czband,1,'db2');
[cc4 ,lc4]= wavedec(c4band,1,'db2');
C3band = appcoef(cc3,lc3,'db2'); 
Czband = appcoef(ccz,lcz,'db2'); 
C4band = appcoef(cc4,lc4,'db2'); 
[C3welch,f] = pwelch(C3band);
[Czwelch,f] = pwelch(Czband);
[C4welch,f] = pwelch(C4band);
f=(f/(2*pi))*80;
%figure(x);
%plot(f,C3welch,f,C4welch,f,Czwelch);
%title('Evento',tipoevento);
%xlabel('Frecuencia[Hz]');
%ylabel('DPS C3 y C4');
%Ritmoalfa
c3alfa= filter(Alfa,c3aux);
c4alfa= filter(Alfa,c4aux);
czalfa= filter(Alfa,czaux);
%realizamos wavalet para bajar el numero de muestras para la extracion de
%caracteristicas
[cc3 ,lc3]= wavedec(c3alfa,1,'db2');
[ccz ,lcz]= wavedec(czalfa,1,'db2');
[cc4 ,lc4]= wavedec(c4alfa,1,'db2');
C3alfa = appcoef(cc3,lc3,'db2'); 
Czalfa = appcoef(ccz,lcz,'db2'); 
C4alfa = appcoef(cc4,lc4,'db2'); 
c3VARa=var(C3alfa);
czVARa=var(Czalfa);
c4VARa=var(C4alfa);
c3COVARa=cov(C3alfa);
czCOVARa=cov(Czalfa);
c4COVARa=cov(C4alfa);
c3MEANa=mean(C3alfa);
czMEANa=mean(Czalfa);
c4MEANa=mean(C4alfa);
c3STDa=std(C3alfa);
czSTDa=std(Czalfa);
c4STDa=std(C4alfa);
c3MAXa=max(C3alfa);
czMAXa=max(Czalfa);
c4MAXa=max(C4alfa);
c3MINa=min(C3alfa);
czMINa=min(Czalfa);
c4MINa=min(C4alfa);

[C3welchalfa,f] = pwelch(C3alfa);
[Czwelchalfa,f] = pwelch(Czalfa);
[C4welchalfa,f] = pwelch(C4alfa);
f=(f/(2*pi))*80;
%figure(x);
%plot(f,C3welchalfa,f,C4welchalfa);
%title('Evento',tipoevento);
%Transformada de Fourier
C3alfa=abs(fft(C3alfa));
Czalfa=abs(fft(Czalfa));
C4alfa=abs(fft(C4alfa));
C3alfa=C3alfa(32:53);
Czalfa=Czalfa(32:53);
C4alfa=C4alfa(32:53);
n=length(C3alfa);
n=(0:n-1)/(n-1)*30;
%realizamos extracion de caracteristicas
%figure(x);
%plot(n,C3,n,C4);
title('FTF signal C3 y C4 evento',tipoevento);
xlabel('Frecuencia[Hz]');
ylabel('DPS C3 y C4');
C3VARa=var(C3alfa);
CzVARa=var(Czalfa);
C4VARa=var(C4alfa);
C3COVARa=cov(C3alfa);
CzCOVARa=cov(Czalfa);
C4COVARa=cov(C4alfa);
C3MEANa=mean(C3alfa);
CzMEANa=mean(Czalfa);
C4MEANa=mean(C4alfa);
C3STDa=std(C3alfa);
CzSTDa=std(Czalfa);
C4STDa=std(C4alfa);
C3MAXPSDa=max(C3welchalfa);
CzMAXPSDa=max(Czwelchalfa);
C4MAXPSDa=max(C4welchalfa);

%ritmo Theta
c3theta= filter(Theta,c3aux);
c4theta= filter(Theta,c4aux);
cztheta= filter(Theta,czaux);
%realizamos wavalet para bajar el numero de muestras para la extracion de
%caracteristicas
[cc3 ,lc3]= wavedec(c3theta,1,'db2');
[ccz ,lcz]= wavedec(cztheta,1,'db2');
[cc4 ,lc4]= wavedec(c4theta,1,'db2');
C3theta = appcoef(cc3,lc3,'db2'); 
Cztheta = appcoef(ccz,lcz,'db2'); 
C4theta = appcoef(cc4,lc4,'db2'); 
c3VARt=var(C3theta);
czVARt=var(Cztheta);
c4VARt=var(C4theta);
c3COVARt=cov(C3theta);
czCOVARt=cov(Cztheta);
c4COVARt=cov(C4theta);
c3MEANt=mean(C3theta);
czMEANt=mean(Cztheta);
c4MEANt=mean(C4theta);
c3STDt=std(C3theta);
czSTDt=std(Cztheta);
c4STDt=std(C4theta);
c3MAXt=max(C3theta);
czMAXt=max(Cztheta);
c4MAXt=max(C4theta);
c3MINt=min(C3theta);
czMINt=min(Cztheta);
c4MINt=min(C4theta);
[C3welchtheta,f] = pwelch(C3theta);
[Czwelchtheta,f] = pwelch(Cztheta);
[C4welchtheta,f] = pwelch(C4theta);
f=(f/(2*pi))*80;
%figure(102);
%plot(f,C3welch,f,C4welch,f,Czwelch);
%Transformada de Fourier
C3theta=abs(fft(C3theta));
Cztheta=abs(fft(Cztheta));
C4theta=abs(fft(C4theta));
C3theta=C3theta(16:32);
Cztheta=Cztheta(16:32);
C4theta=C4theta(16:32);
n=length(C3theta);
n=(0:n-1)/(n-1)*30;
%realizamos extracion de caracteristicas
%figure(x);
%plot(n,C3,n,C4);
title('FTF signal C3 y C4 evento',tipoevento);
xlabel('Frecuencia[Hz]');
ylabel('DPS C3 y C4');
C3VARt=var(C3theta);
CzVARt=var(Cztheta);
C4VARt=var(C4theta);
C3COVARt=cov(C3theta);
CzCOVARt=cov(Cztheta);
C4COVARt=cov(C4theta);
C3MEANt=mean(C3theta);
CzMEANt=mean(Cztheta);
C4MEANt=mean(C4theta);
C3STDt=std(C3theta);
CzSTDt=std(Cztheta);
C4STDt=std(C4theta);
C3MAXPSDt=max(C3welchtheta);
CzMAXPSDt=max(Czwelchtheta);
C4MAXPSDt=max(C4welchtheta);

%ritmo delta
c3delta= filter(Delta,c3aux);
c4delta= filter(Delta,c4aux);
czdelta= filter(Delta,czaux);
%realizamos wavalet para bajar el numero de muestras para la extracion de
%caracteristicas
[cc3 ,lc3]= wavedec(c3delta,1,'db2');
[ccz ,lcz]= wavedec(czdelta,1,'db2');
[cc4 ,lc4]= wavedec(c4delta,1,'db2');
C3delta = appcoef(cc3,lc3,'db2'); 
Czdelta = appcoef(ccz,lcz,'db2'); 
C4delta = appcoef(cc4,lc4,'db2'); 
c3VARd=var(C3delta);
czVARd=var(Czdelta);
c4VARd=var(C4delta);
c3COVARd=cov(C3delta);
czCOVARd=cov(Czdelta);
c4COVARd=cov(C4delta);
c3MEANd=mean(C3delta);
czMEANd=mean(Czdelta);
c4MEANd=mean(C4delta);
c3STDd=std(C3delta);
czSTDd=std(Czdelta);
c4STDd=std(C4delta);
c3MAXd=max(C3delta);
czMAXd=max(Czdelta);
c4MAXd=max(C4delta);
c3MINd=min(C3delta);
czMINd=min(Czdelta);
c4MINd=min(C4delta);
[C3welchdelta,f] = pwelch(C3delta);
[Czwelchdelta,f] = pwelch(Czdelta);
[C4welchdelta,f] = pwelch(C4delta);
f=(f/(2*pi))*80;
%figure(102);
%plot(f,C3welch,f,C4welch,f,Czwelch);
%Transformada de Fourier
C3delta=abs(fft(C3delta));
Czdelta=abs(fft(Czdelta));
C4delta=abs(fft(C4delta));
C3delta=C3delta(2:16);
Czdelta=Czdelta(2:16);
C4delta=C4delta(2:16);
n=length(C3delta);
n=(0:n-1)/(n-1)*30;
%realizamos extracion de caracteristicas
%figure(x);
%plot(n,C3,n,C4);
title('FTF signal C3 y C4 evento',tipoevento);
xlabel('Frecuencia[Hz]');
ylabel('DPS C3 y C4');
C3VARd=var(C3delta);
CzVARd=var(Czdelta);
C4VARd=var(C4delta);
C3COVARd=cov(C3delta);
CzCOVARd=cov(Czdelta);
C4COVARd=cov(C4delta);
C3MEANd=mean(C3delta);
CzMEANd=mean(Czdelta);
C4MEANd=mean(C4delta);
C3STDd=std(C3delta);
CzSTDd=std(Czdelta);
C4STDd=std(C4delta);
C3MAXPSDd=max(C3welchdelta);
CzMAXPSDd=max(Czwelchdelta);
C4MAXPSDd=max(C4welchdelta);

%ritmo beta
c3beta= filter(Beta,c3aux);
c4beta= filter(Beta,c4aux);
czbeta= filter(Beta,czaux);
%realizamos wavalet para bajar el numero de muestras para la extracion de
%caracteristicas
[cc3 ,lc3]= wavedec(c3beta,1,'db2');
[ccz ,lcz]= wavedec(czbeta,1,'db2');
[cc4 ,lc4]= wavedec(c4beta,1,'db2');
C3beta = appcoef(cc3,lc3,'db2'); 
Czbeta = appcoef(ccz,lcz,'db2'); 
C4beta = appcoef(cc4,lc4,'db2'); 
c3VARb=var(C3beta);
czVARb=var(Czbeta);
c4VARb=var(C4beta);
c3COVARb=cov(C3beta);
czCOVARb=cov(Czbeta);
c4COVARb=cov(C4beta);
c3MEANb=mean(C3beta);
czMEANb=mean(Czbeta);
c4MEANb=mean(C4beta);
c3STDb=std(C3beta);
czSTDb=std(Czbeta);
c4STDb=std(C4beta);
c3MAXb=max(C3beta);
czMAXb=max(Czbeta);
c4MAXb=max(C4beta);
c3MINb=min(C3beta);
czMINb=min(Czbeta);
c4MINb=min(C4beta);
[C3welchbeta,f] = pwelch(C3beta);
[Czwelchbeta,f] = pwelch(Czbeta);
[C4welchbeta,f] = pwelch(C4beta);
f=(f/(2*pi))*80;
%figure(102);
%plot(f,C3welch,f,C4welch,f,Czwelch);
%Transformada de Fourier
C3beta=abs(fft(C3beta));
Czbeta=abs(fft(Czbeta));
C4beta=abs(fft(C4beta));
C3beta=C3beta(52:121);
Czbeta=Czbeta(52:121);
C4beta=C4beta(52:121);
n=length(C3beta);
n=(0:n-1)/(n-1)*30;
%realizamos extracion de caracteristicas
%figure(x);
%plot(n,C3,n,C4);
title('FTF signal C3 y C4 evento',tipoevento);
xlabel('Frecuencia[Hz]');
ylabel('DPS C3 y C4');
C3VARb=var(C3beta);
CzVARb=var(Czbeta);
C4VARb=var(C4beta);
C3COVARb=cov(C3beta);
CzCOVARb=cov(Czbeta);
C4COVARb=cov(C4beta);
C3MEANb=cov(C3beta);
CzMEANb=cov(Czbeta);
C4MEANb=cov(C4beta);
C3STDb=std(C3beta);
CzSTDb=std(Czbeta);
C4STDb=std(C4beta);
C3MAXPSDb=max(C3welchbeta);
CzMAXPSDb=max(Czwelchbeta);
C4MAXPSDb=max(C4welchbeta);

if tipoevento == "T2"
    if (sesion==4)||(sesion==8)||(sesion==12)
     ETIQUETA=1;
    else
     ETIQUETA=3;
    end
elseif tipoevento == "T0"
    ETIQUETA =0;
else 
    if (sesion==4)||(sesion==8)||(sesion==12)
     ETIQUETA=2;
    else
     ETIQUETA=4;
    end
end
 DAT = [ C3VARa,C3COVARa,C3MEANa,C3STDa,C3MAXPSDa,c3VARa,c3COVARa,c3MEANa,c3STDa,c3MAXa,c3MINa,CzVARa,CzCOVARa,CzMEANa,CzMAXPSDa,CzSTDa,czVARa,czCOVARa,czMEANa,czSTDa,czMAXa,czMINa,C4VARa,C4COVARa,C4MEANa,C4MAXPSDa,C4STDa,c4VARa,c4COVARa,c4MEANa,c4STDa,c4MAXa,c4MINa,C3VARb,C3COVARb,C3MEANb,C3MAXPSDb,C3STDb,c3VARb,c3COVARb,c3MEANb,c3STDb,c3MAXb,c3MINb,CzVARb,CzCOVARb,CzMEANb,CzMAXPSDb,CzSTDb,czVARb,czCOVARb,czMEANb,czSTDb,czMAXb,czMINb,C4VARb,C4COVARb,C4MEANb,C4MAXPSDb,C4STDb,c4VARb,c4COVARb,c4MEANb,c4STDb,c4MAXb,c4MINb,C3VARd,C3COVARd,C3MEANd,C3MAXPSDd,C3STDd,c3VARd,c3COVARd,c3MEANd,c3STDd,c3MAXd,c3MINd,CzVARd,CzCOVARd,CzMEANd,CzMAXPSDd,CzSTDd,czVARd,czCOVARd,czMEANd,czSTDd,czMAXd,czMINd,C4VARd,C4COVARd,C4MEANd,C4MAXPSDd,C4STDd,c4VARd,c4COVARd,c4MEANd,c4STDd,c4MAXd,c4MINd,C3VARt,C3COVARt,C3MEANt,C3MAXPSDt,C3STDt,c3VARt,c3COVARt,c3MEANt,c3STDt,c3MAXt,c3MINt,CzVARt,CzCOVARt,CzMEANt,CzMAXPSDt,CzSTDt,czVARt,czCOVARt,czMEANt,czSTDt,czMAXt,czMINt,C4VARt,C4COVARt,C4MEANt,C4MAXPSDt,C4STDt,c4VARt,c4COVARt,c4MEANt,c4STDt,c4MAXt,c4MINt,ETIQUETA];
 if x>1
    DATOS =[DATOS;DAT];
 else
    DATOS= DAT;
 end
end
 if sesion>4
    SUJETO =[SUJETO;DATOS];
 else
    SUJETO= DATOS;
 end
end
 if sujetos>1
    BaseDatos =[BaseDatos;SUJETO];
 else
    BaseDatos= SUJETO;
 end
end