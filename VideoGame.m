% %% configure serial port
% a = instrfind;
% if ~isempty(a)
%     fclose(a)
%     delete(a)
% end
% 
% %% Open serial port for talking to joystick 
% s = serial('COM11');
% set(s, 'BaudRate', 9600);
% set(s, 'Parity', 'None');
% set(s, 'StopBits', 1);
% set(s, 'FlowControl', 'None');
% set(s, 'TimeOut', 0.5);
% fopen(s); 

%% Main Game loop   
    
    collison = 100; %initializing for the loop
    
%*****************************Create the Screen ***************************

    close all
    fig = figure();
    ax = axes(fig,'Position',[0 0 1 1]);
    ax.DataAspectRatio = [1 1 1]; % set to have equal axes
    ax.XLim = [0 640]; % set up world boundaries
    ax.YLim = [0 480];
    ax.Color = [0 0 0]; %black sky
    T = 1/20; % 20 Hz refresh rate
    
    %Make backgroud the moon
    f2 = figure() % create a new figure temporarily for loading the graphic
    [x,map,alpha] = imread('moonrgb.png');
    h = image(x);
    h.Parent = ax % move it from the temp figure to the world axes
    h.CDataMapping = 'scaled'
    h.XData = [0 640];
    h.YData = [480 0]; % this is necessary to flip the graphic so it displays right side up
    delete(f2)
    
    %Make landing platform
    f4 = figure() % create a new figure temporarily for loading the graphic
    [x,map,alpha] = imread('platform.png');
    h3 = image(x);
    h3.Parent = ax % move it from the temp figure to the world axes
    h3.AlphaData = alpha;
    h3.XData = [1 75]+randi(610);
    h3.YData = [75 1]+randi(200); % this is necessary to flip the graphic so it displays right side up
    delete(f4) % delete the temp figure
    
    % make the Lunar lander
    f3 = figure() % create a new figure temporarily for loading the graphic
    [x,map,alpha] = imread('mars_lander.png');
    h2 = image(x);
    h2.Parent = ax % move it from the temp figure to the world axes
    h2.AlphaData = alpha;
    h2.XData = [1 32]+320;
    h2.YData = [32 1]+500; % this is necessary to flip the graphic so it displays right side up
    delete(f3) % delete the temp figure
   
% Create gamepad object
gamepad = KeyboardEmulator(fig);
gamepad.mapButton('z',1);
gamepad.mapButton('a',2);
gamepad.mapButton('s',3);
% Create a PS3 gamepad object
%gamepad = PS3Controller('COM12');

% Starting Sound effects
%[y, Fs] = audioread('countdown.wav');
%countdown_sound = audioplayer(y,Fs);
%[y, Fs] = audioread('launch.wav');
%launch_sound = audioplayer(y, Fs);
%countdown_sound.playblocking;
%launch_sound.playblocking;
        
% Sound for lunar lander
%[y, Fs] = audioread('beep.wav');
%beep_sound = audioplayer(y,Fs);

DT = 1/100;
while(collison>20)
    %beep_sound.play
    %flushinput(s);
    %dat = fscanf(s)
    %dat = read_keyboard_filled(fig);
     gamepad.update()
    
     %try
      %  [name, btnstr, jlx, jly, jrx, jry] = strread( dat, '%s%s%f%f%f%f', 1, 'delimiter', ',');
       %  btn = hex2dec(btnstr);
        %if isempty(btn)
%        good = 0;
%        else 
%        good = 1;
%        end
%    catch
%        good = 0;
%        display('Bad data');
%    end
%    
%    if (good)
        
         % set velocities

        vx = 7*(gamepad.jlx) % lateral
        
        vy = -5; % vertical
%        if ~(bitand(btn,2^7))
        if(gamepad.isPressed(2)) % a or button 2 thruster up 
           vy = 5;
        elseif(gamepad.isPressed(1)) % z or button 1 thruster down
        %elseif ~(bitand(btn,2^4))
           vy = -8; 
        end
        % use bitand(btn,2^whatever) to check for button presses
        
        %Ship animation
        %thrust = (65535-btn)/16; 
        %if(thrust == 16)
        %    thrust = -3
        %end
            
            %btn1 = 65407;    ***notes to remember decimal values of the
            %btn3 = 65519;       buttons in use***   
            %NObtn= 65535;
%    end
        h2.XData = h2.XData + vx; % move the lander to the right or left
        h2.YData = (h2.YData) + vy; % moving downward at a constant right that changes if button 1 or 3 is pressed
        pause(DT);
        
        % check if you are near the pad
        distance_x = mean(h2.XData)-mean(h3.XData);
        distance_y = mean(h2.YData)-mean(h3.YData);
        distance = sqrt(distance_x^2 + distance_y^2);
        if (distance < 10)
            collison = 20; % collision is some code that says if you hit or not?        
        elseif mean(h2.YData) < 0
            collision = -20; % overshot bottom of screen - we die. 
        end
    
    if (gamepad.isPressed(3)) % s or button 3 is quit? 
        collison = -20;
    end


end




% Tell user how they did
endmsg = text(320,400,'msg'); % create some text
endmsg.Color = 'w'
endmsg.FontSize = 16;
endmsg.FontWeight = 'bold';
endmsg.HorizontalAlignment = 'center'
% message depends on if we hit the pad or not
if(collison>0)
    endmsg.String = 'Welcome to the moon, astronaut!';
elseif(collison<0)
    endmsg.String = 'Houston we have a problem...';
end
 