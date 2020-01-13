function varargout = gusanito(varargin)
% GUSANITO MATLAB code for gusanito.fig
%      GUSANITO, by itself, creates a new GUSANITO or raises the existing
%      singleton*.
%
%      H = GUSANITO returns the handle to a new GUSANITO or the handle to
%      the existing singleton*.
%
%      GUSANITO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUSANITO.M with the given input arguments.
%
%      GUSANITO('Property','Value',...) creates a new GUSANITO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gusanito_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gusanito_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gusanito

% Last Modified by GUIDE v2.5 21-May-2018 05:37:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gusanito_OpeningFcn, ...
                   'gui_OutputFcn',  @gusanito_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gusanito is made visible.
function gusanito_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gusanito (see VARARGIN)

% Choose default command line output for gusanito
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gusanito wait for user response (see UIRESUME)
% uiwait(handles.figure1);
globals();
initialize();

% --- Outputs from this function are returned to the command line.
function varargout = gusanito_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global GAMEOVER;
global SCORE;
global WORM;
global STOP;
handles.lbl_keypressed_value.String = eventdata.Key;
if GAMEOVER == 0
    if strcmp(eventdata.Key, 'uparrow') || strcmp(eventdata.Key, 'downarrow') || strcmp(eventdata.Key, 'leftarrow') || strcmp(eventdata.Key, 'rightarrow')
        change_direction(eventdata.Key);
        update_ui(handles);
%         initial_pos=[WORM(1,:)];
%         food_pos=[str2num(handles.txt_food_pos_x.String) str2num(handles.txt_food_pos_y.String)];
%         new_pos=handle_keypress(eventdata.Key, initial_pos);
%         if check_wall_collision(new_pos) ~= -1
%             GAMEOVER=1;
%         elseif check_worm_collision(new_pos)~= -1
%             % end of game
%         elseif check_food_collision(new_pos, food_pos) ~= -1
%             % increase worm length
%             WORM=[new_pos;WORM];
%             SCORE=SCORE+1;
%         end
% 
%         if GAMEOVER == 0
%             update_ui(handles);
%             update_pos(new_pos, handles);
%         else
%             %STOP
%             handles.lbl_state.String=':(';
%         end
    end
end

% --- Executes on button press in tgl_btn_play.
function tgl_btn_play_Callback(hObject, eventdata, handles)
% hObject    handle to tgl_btn_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tgl_btn_play
global DIRECTION;
global GAMEOVER;
global WORM;
global STOP;
global SCORE;
global DELAY;

globals();
initialize();

d=get(hObject,'Value');
if d==1
    handles.tgl_btn_play.String = 'STOP';
    g=1;
    while g
        if STOP == 0  
            food_pos=[str2num(handles.txt_food_pos_x.String) str2num(handles.txt_food_pos_y.String)];
            if get(hObject, 'Value') == 0
                break
            end
            new_pos=WORM(1,:);
            switch DIRECTION
                case 'NORTH'
                    new_pos(1)=new_pos(1)-1;
                case 'SOUTH'
                    new_pos(1)=new_pos(1)+1;
                case 'EAST'
                    new_pos(2)=new_pos(2)+1;
                case 'WEST'
                    new_pos(2)=new_pos(2)-1;
            end

            if check_wall_collision(new_pos) ~= -1
                GAMEOVER=1;
                handles.lbl_state.String=':(';
                handles.tgl_btn_play.String = 'PLAY';
                break;
            elseif check_worm_collision(new_pos)~= -1
                % end of game
                GAMEOVER=1;
                handles.lbl_state.String=':(';
                handles.tgl_btn_play.String = 'PLAY';
                break;
            elseif check_food_collision(new_pos, food_pos) ~= -1
                % increase worm length
                WORM=[new_pos;WORM];
                SCORE=SCORE+1;
                % create a new food location
                a=10;
                b=90;
                
                x = ceil(a + (b-a).*rand(1));
                y = ceil(a + (b-a).*rand(1));
                
                handles.txt_food_pos_x.String = x;
                handles.txt_food_pos_y.String = y;
                DELAY=DELAY-DELAY*(5e-2);
                handles.txt_delay.String = DELAY;
            else
                update_pos(new_pos, handles);
            end
        end
        pause(DELAY);
    end
else
    handles.tgl_btn_play.String = 'PLAY';
end

function initialize()
global DIMENSIONS;
% initialize variables
img=ones(DIMENSIONS(1),DIMENSIONS(2),3); %initialize
start=[ceil(DIMENSIONS(1)/2) ceil(DIMENSIONS(2)/2)];
food_start=[ceil(DIMENSIONS(1)/3) ceil(DIMENSIONS(1)/3)];

%set starting location
img(start(1),start(2),1:1:3)=0;
img(food_start(2),food_start(1),1:1:2)=0.3;

%display image
imshow(img);
handles.txt_pos_x.String = start(1);
handles.txt_pos_y.String = start(2);
handles.txt_food_pos_x.String = food_start(2);
handles.txt_food_pos_y.String = food_start(1);
handles.txt_score.String=0;

function update_pos(pos,handles)
global DIMENSIONS;
global WORM;
global SCORE;
img=ones(DIMENSIONS(1),DIMENSIONS(2),3);

food_pos=[str2num(handles.txt_food_pos_x.String) str2num(handles.txt_food_pos_y.String)];

if SCORE > 0
    WORM=[pos; WORM(1:end-1,:)];
else
    WORM(1,:)=[pos];
end

for i= 1:1:size(WORM,1)
    img(WORM(i, 1),WORM(i, 2),1:1:3)=0;
end

img(food_pos(1),food_pos(2),1:1:2)=0.3;

handles.txt_pos_x.String = pos(1);
handles.txt_pos_y.String = pos(2);
imshow(img);

function change_direction(key)
global DIRECTION;
    switch DIRECTION
            case 'NORTH'
                switch key
                    case 'rightarrow'
                        DIRECTION='EAST';
                    case 'leftarrow'
                        DIRECTION='WEST';
                end
            case 'SOUTH'
                switch key
                    case 'rightarrow'
                        DIRECTION='EAST';
                    case 'leftarrow'
                        DIRECTION='WEST';
                end
            case 'EAST'
                switch key
                    case 'uparrow'
                        DIRECTION='NORTH';
                    case 'downarrow'
                        DIRECTION='SOUTH';
                end
            case 'WEST'
                switch key
                    case 'uparrow'
                        DIRECTION='NORTH';
                    case 'downarrow'
                        DIRECTION='SOUTH';
                end                
    end
        
function new_pos = handle_keypress(key, pos)
global DIRECTION;
    switch DIRECTION
            case 'NORTH'
                switch key
                    case 'rightarrow'
                        pos(2)=pos(2)+1;
                        DIRECTION='EAST';
                    case 'leftarrow'
                        pos(2)=pos(2)-1;
                        DIRECTION='WEST';
                end
            case 'SOUTH'
                switch key
                    case 'rightarrow'
                        pos(2)=pos(2)+1;
                        DIRECTION='EAST';
                    case 'leftarrow'
                        pos(2)=pos(2)-1;
                        DIRECTION='WEST';
                end
            case 'EAST'
                switch key
                    case 'uparrow'
                        pos(1)=pos(1)-1;
                        DIRECTION='NORTH';
                    case 'downarrow'
                        pos(1)=pos(1)+1;
                        DIRECTION='SOUTH';
                end
            case 'WEST'
                switch key
                    case 'uparrow'
                        pos(1)=pos(1)-1;
                        DIRECTION='NORTH';
                    case 'downarrow'
                        pos(1)=pos(1)+1;
                        DIRECTION='SOUTH';
                end                
    end
    new_pos=pos;

function result = check_wall_collision(pos)
global DIMENSIONS;
result = -1;

if pos(2) ==0 || pos(1)==0 || pos(1) > DIMENSIONS(1) || pos(2) > DIMENSIONS(2)
    result = 1;
end

function result = check_worm_collision(pos)
global SCORE;
global WORM;
    result=-1;
    
    if SCORE > 0
        for i=2:1:size(WORM,1)
            if pos(2) == WORM(i,2) && pos(1) == WORM(i,1)
                result=1;
            end
        end
    end

function result = check_food_collision(pos, food_pos)
    result=-1;
    
    if pos(2) == food_pos(2) && pos(1) == food_pos(1)
        result = 1;
    end
    
function update_ui(handles)
global DIRECTION;
global SCORE;
handles.lbl_direction.String=DIRECTION;
handles.txt_score.String=SCORE;
        
function globals()
global WORM;
global GAMEOVER;
global DIMENSIONS;
global DIRECTION;
global SCORE;
global STOP;
global DELAY;

WORM=[50 50];
GAMEOVER=0;
DIMENSIONS=[100 100];
DIRECTION = 'NORTH';
SCORE=0;
STOP=0;
DELAY=50e-3;