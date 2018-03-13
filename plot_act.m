function  plot_act(act, actime, readytime, state, fig)
    R_time = [2 2 5];    
    
    figure(fig);  
    xticks(1:13);
    yticks(unique(sort(actime)));
    xlim([0,14]);
    grid on;
    set(gca,'ydir','reverse')
    ylabel('actime');
    xlabel('Tank Id');
    hold on;
    %plot_station(fig);
    %画R1和R2动作
    idx_R1 = act(:,1)~=0;  
    idx_R1(1) = true;
    act_R1 = act(idx_R1, :);
    actime_R1 = actime(idx_R1);
    plot_Robot(act_R1, actime_R1, 1, 2, 'r');
    idx_R2 = act(:,3)~=0;  
    idx_R2(1) = true;
    act_R2 = act(idx_R2, :);
    actime_R2 = actime(idx_R2);
    plot_Robot(act_R2, actime_R2, 3, 4, 'b');
    
    %
    hold off;
       
    
    
    %R1: plot_Robot(1, 2, 'r');
    %R2: plot_Robot(3, 4, 'b');
    function plot_Robot(act, actime, act_start_col, act_end_col, color)
        num_act = length(actime); 
        R_lines_x = [act(1, act_end_col), act(1, act_end_col)];
        R_lines_y = [actime(1), actime(1)];
        
                
        R_c = 1;
        for k = 2:num_act                        
            if act(k, act_start_col) ~= 0 %R1有动作:从act(k, 1)腔室移动到act(k, 2)腔室            
                if act(k - 1, act_start_col) ~= 0
                    %预处理：当act(k, 1) == 0 时，若act(k, 2) == 0,则令act(k,2)==act(k-1,2)。处理act=[0,0,....]的情况                
                    if act(k, act_start_col) ~= act(k - 1, act_end_col)%需要动作补间
                        time_move = R_time(1) + R_time(2) + R_time(3) * abs(act(k - 1, act_end_col) - act(k - 1, act_start_col)); %R1                    
                        time_prepare = R_time(1) + R_time(2) + R_time(3) * abs(act(k - 1, act_end_col) - act(k, act_start_col)); %R1
                        %R1动作补间act(k-1, 2) -> act(k-1, 2)                                    
                        R_lines_x(R_c + 1, :) = [act(k - 1, act_end_col), act(k - 1, act_end_col)];
                        R_lines_y(R_c + 1, :) = [actime(k - 1) + time_move, actime(k) - time_prepare];
                        R_c = R_c + 1;
                        fprintf('stay %d %d %d %d\n', R_lines_x(R_c, 1), R_lines_x(R_c, 2),R_lines_y(R_c, 1), R_lines_y(R_c, 2) );
                        %R1动作补间act(k-1, 2) -> act(k, 1)                                    
                        R_lines_x(R_c + 1, :) = [act(k - 1, act_end_col), act(k, act_start_col)];
                        R_lines_y(R_c + 1, :) = [actime(k) - time_prepare, actime(k)];
                        R_c = R_c + 1;
                        fprintf('prepare %d %d %d %d\n', R_lines_x(R_c, 1), R_lines_x(R_c, 2),R_lines_y(R_c, 1), R_lines_y(R_c, 2) );
                    else                                                
                        time_move = R_time(1) + R_time(2) + R_time(3) * abs(act(k - 1, act_start_col) - act(k - 1, act_end_col)); %R1                        
                        R_lines_x(R_c + 1, :) = [act(k - 1, act_end_col), act(k, act_start_col)];
                        R_lines_y(R_c + 1, :) = [actime(k - 1) + time_move, actime(k)];
                        R_c = R_c + 1;
                        fprintf('continue %d %d %d %d\n', R_lines_x(R_c, 1), R_lines_x(R_c, 2),R_lines_y(R_c, 1), R_lines_y(R_c, 2) );
                    end   

                    %按照act画出R1动作线act(k, 1) -> act(k, 2)
                    time_move = R_time(1) + R_time(2) + R_time(3) * abs(act(k, act_start_col) - act(k, act_end_col)); %R1
                    R_lines_x(R_c + 1, :) = [act(k, act_start_col), act(k, act_end_col)];
                    R_lines_y(R_c + 1, :) = [actime(k), actime(k) + time_move];
                    R_c = R_c + 1;   
                    fprintf('move %d %d %d %d\n', R_lines_x(R_c, 1), R_lines_x(R_c, 2),R_lines_y(R_c, 1), R_lines_y(R_c, 2) );
                else
                    if act(k, act_start_col) ~= act(k - 1, act_end_col)
                        time_prepare = R_time(1) + R_time(2) + R_time(3) * abs(act(k - 1, act_end_col) - act(k, act_start_col)); 
                        R_lines_x(R_c + 1, :) = [act(k - 1, act_end_col), act(k, act_end_col)];
                        R_lines_y(R_c + 1, :) = [actime(k - 1), actime(k)  - time_prepare ];
                        R_c = R_c + 1;
                        
                        R_lines_x(R_c + 1, :) = [act(k - 1, act_end_col), act(k, act_start_col)];
                        R_lines_y(R_c + 1, :) = [actime(k)  - time_prepare, actime(k)];
                        R_c = R_c + 1;
                        
                        time_move = R_time(1) + R_time(2) + R_time(3) * abs(act(k, act_start_col) - act(k, act_end_col));
                        R_lines_x(R_c + 1, :) = [act(k, act_start_col), act(k, act_end_col)];
                        R_lines_y(R_c + 1, :) = [actime(k), actime(k) + time_move ];
                        R_c = R_c + 1;
                    else
                        R_lines_x(R_c + 1, :) = [act(k - 1, act_end_col), act(k, act_start_col)];
                        R_lines_y(R_c + 1, :) = [actime(k - 1), actime(k)];
                        R_c = R_c + 1;
                        
                        time_move = R_time(1) + R_time(2) + R_time(3) * abs(act(k, act_start_col) - act(k, act_end_col));
                        R_lines_x(R_c + 1, :) = [act(k, act_start_col), act(k, act_end_col)];
                        R_lines_y(R_c + 1, :) = [actime(k), actime(k) + time_move ];
                        R_c = R_c + 1;
                    end
                end            
            end
        end
        plot(R_lines_x', R_lines_y', color);
    end
end