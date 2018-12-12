%% Matlab keyboard joystick program
%
% this code give the framework for a joystick emulator that receives input
% from the keyboard instead of the joystick. the code is incomplete and
% requires the student to add code to create the joystick commands when
% certain keystrokes occur. the portion of the code that needs modification
% is denoted below. the variables KeyBUT, KeyJLX, KeyJLY, KeyJRX and KeyJRY contain
% the values of the joystick buttons, and left and right x-axis, y-axis . these
% variables are used to emulate the joystick output string. modifying these
% variables changes the commands embedded within the joystick string.
%
% R. Broussard, 11 Nov 2013
% Modified: S.L. Noble, 14 Nov 2013
% Modified: J. Piepmeier 17 Nov 2016 to match gamepad

function [STR] = read_keyboard_filled(k)      %   This is the main function
global Key %makes Key a global variable

KeyBUT = 2^16-1; % default state of buttons on gamepad
KeyJLX = 511;    % you might modify these if your joystick doesn't rest here
KeyJLY = 511;
KeyJRX = 511;
KeyJRY = 511;

%if you are using right joystick, copy above 4 lines to create KeyJRX,etc

if strcmp(get(k,'WindowKeyPressFcn'),'')
    % tell MATLAB to execute the function key_pressed() whenever a key is pressed
    set(k, 'WindowKeyPressFcn', @key_pressed);
    Key = ' '; % The character read from the keyboard (initially space)
end

%*******************************************************************
% your code modifications go here
% if a key has been pressed
if Key~=' '
    %fprintf('Key pressed is %c\n',Key);
%********* Left Joystick ****************    
    if strcmp(Key,'leftarrow') % compare the string
        KeyJLX=211;
    end

    if strcmp(Key,'rightarrow')
        KeyJLX=811;
    end

    if strcmp(Key,'downarrow')
        KeyJLY=211;
    end

    if strcmp(Key,'uparrow')
        KeyJLY=811;
    end    
   
%********** Pick what letters or keys you want for the various switches
    if Key=='q' %SW0 Trigger
        KeyBUT=KeyBUT - 2^7;
    end

    if Key=='z' %SW11 Trigger
        KeyBUT=KeyBUT - 2^4;
    end

      
end

% your code modifications end here
%*******************************************************************
STR=sprintf('$JOYSTK,%s,%d,%d,%d,%d*1B\n',dec2hex(KeyBUT),KeyJLX,KeyJLY,KeyJRX,KeyJRY);
Key=' ';

% This function runs when you press a keyboard key when figure 1 is active
    function key_pressed(k, evnt)    % This function runs when you press
        % a keyboard key when figure 1 is active
        Key = evnt.Key;        % Gets the character pressed
    end
end

