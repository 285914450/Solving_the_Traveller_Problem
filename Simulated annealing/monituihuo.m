close all;
clc,clear                               %��ջ����еı���
tic
iter = 1;                               %����������ֵ
a=0.99;                                 %�¶�˥��ϵ��
t0=97;                                  %��ʼ�¶�
tf=3;                                   %����¶�
t=t0;
Markov=500;                           %Markov������
load posi.txt                          %������е�����
city=posi;
n = size(city,1);                       %������Ŀ
D = zeros(n,n);                                                    
for i = 1:n                             
    for j = 1:n
        D(i,j) = sqrt(sum((city(i,:) - city(j,:)).^2));    
    end    
end                                                                                
route=1:n;         %������ʼ�⣬route��ÿ�β������½�                     
route_new=route;   %route_new�ǵ�ǰ��
best_route=route;  %best_route����ȴ�е���ý�
Length=Inf;        %Length�ǵ�ǰ���Ӧ�Ļ�·����
best_length=Inf;   %best_length�����Ž�

%%
while t>=tf
    for j=1:Markov
	%��������Ŷ�,�����µ�����route_new;
        if (rand<0.7)
        %������������˳��
            ind1=0;ind2=0;
            while(ind1==ind2&&ind1>=ind2)
                ind1=ceil(rand*n);          %��һȡ��
                ind2=ceil(rand*n);
            end                      
            temp=route_new(ind1);
            route_new(ind1)=route_new(ind2);
            route_new(ind2)=temp;
        else
            %������
            ind=zeros(3,1);
            L_ind=length(unique(ind));
            while (L_ind<3)
                ind=ceil([rand*n rand*n rand*n]);
                L_ind=length(unique(ind));
            end
            ind0=sort(ind);
            a1=ind0(1);b1=ind0(2);c1=ind0(3);
            route0=route_new;
            route0(a1:a1+c1-b1-1)=route_new(b1+1:c1);
            route0(a1+c1-b1:c1)=route_new(a1:b1);
            route_new=route0;    
        end 
        %����·���ľ���,Length_new 
        length_new = 0;
        Route=[route_new route_new(1)];%route_new(1)ָ��һ������
        for j = 1:n
            length_new = length_new+ D(Route(j),Route(j + 1));
        end
        if length_new<Length      
            Length=length_new;
            route=route_new;
            %������·�ߺ;������
            if length_new<best_length
                iter = iter + 1;    
                best_length=length_new;
                best_route=route_new;
            end
        else
            %���½��Ŀ�꺯��ֵ���ڵ�ǰ�⣬
            %�����һ�����ʽ����½�
            if rand<exp(-(length_new-Length)/t)
                route=route_new;
                Length=length_new;
            end
        end
        route_new=route; 
    end              
	t=t*a;  %���Ʋ���t���¶ȣ�����Ϊԭ����a��
end

%% �����ʾ 
toc
Route=[best_route best_route(1)];
xy=[(city(Route ,1)),(city(Route ,2))]
fid=fopen('save1.txt','w+');
fprintf(fid,'%g  %g\n\t\t',xy)
plot([city(Route ,1)], [city(Route ,2)],'o-');
    disp('���Ž�Ϊ��')
    disp(best_route)
    disp('��̾��룺')
    disp(best_length)
    disp('���Ž����������')
    disp(iter)

for i = 1:n
    %��ÿ�����н��б��
%     xy=[city(i,1),city(i,2)]
    text(city(i,1),city(i,2),['   ' num2str(i)]);
end
xlabel('����λ�ú�����')
ylabel('����λ��������')
title(['ģ���˻��㷨(��̾��룩:' num2str(best_length) ''])