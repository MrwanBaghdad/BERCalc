function varargout = BERCalc(varargin)
% BERCalc MATLAB code for BERCalc.fig
%      BERCalc, by itself, creates a new BERCalc or raises the existing
%      singleton*.
%
%      H = BERCalc returns the handle to a new BERCalc or the handle to
%      the existifng singleton*.
%
%      BERCalc('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BERCalc.M with the given input arguments.
%
%      BERCalc('Property','Value',...) creates a new BERCalc or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BERCalc_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BERCalc_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BERCalc

% Last Modified by GUIDE v2.5 18-Apr-2017 20:41:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BERCalc_OpeningFcn, ...
                   'gui_OutputFcn',  @BERCalc_OutputFcn, ...
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

% --- Executes just before BERCalc is made visible.
function BERCalc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BERCalc (see VARARGIN)

% Choose default command line output for BERCalc
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using BERCalc.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes BERCalc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BERCalc_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in run_button.
function run_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% General case: SNR (0 - 30 dB), step size = 2 dB
if strcmp(get(handles.SNR_value,'string'), 'All')
    
    % Initialize SNR values
    SNR_values = [0,0;2,0;4,0;6,0;8,0;10,0;12,0;14,0;16,0;18,0;20,0;22,0;24,0;26,0;28,0;30,0;];
   
    % Compute BER for each SNR
    for index = 1:length(SNR_values)
       
       % Generate random transmitted signal
       txSequence = randi([0 1],1,str2num(get(handles.bit_count,'string'))); 
       
       % Power of transmitted signal
       txPower = mean(txSequence.^2);
       
       % Compute noise based on the SNR
       noise = sqrt( txPower / (2 * SNR_values(index,1) ) ) * ( randn(size(txSequence)) + 1j randn(size(txSequence)) );
       
       % Compute the received signal
       rxSequence = txSequence + noise;
       
       % Approximate received signal based on threshold
       rx_threshold = 0.5;
       for i=1:length(rxSequence)
           
            if (rxSequence(i)<rx_threshold) 
                rxSequence(i)=0;
            else
                rxSequence(i)=1;
            end;
       
        end;
        
        % Compute the BER
        bit_error = biterr(txSequence,rxSequence);
        
        % Update the corresponding BER value in the output table
        SNR_values(index,2) = bit_error;
        
        % Plot the recevied signal
        stem(rxSequence);
    end;
    
    % Update handles
    set(handles.SNR_output,'Data',SNR_values);
else
    % Fetch SNR value
    SNR_value = str2num(get(handles.SNR_value,'string'));
    
    % Generate random transmitted signal
    txSequence = randi([0 1],1,str2num(get(handles.bit_count,'string')));
    
    % Power of transmitted signal
    txPower = mean(txSequence.^2); % Power of transmitted sequence
    
    % Compute noise based on the SNR
    noise = sqrt(txPower/(2*SNR_value))*(randn(size(txSequence))+1j*randn(size(txSequence)));
    
    % Compute the received signal
    rxSequence = txSequence + noise;
    
    % Approximate received signal based on threshold
    rx_threshold = 0.5;
    for i=1:length(rxSequence)
        
        if (rxSequence(i)<rx_threshold) 
            rxSequence(i)=0;
        else
            rxSequence(i)=1;
        end
        
    end
    
    % Compute the BER
    bit_error = biterr(txSequence,rxSequence);
    
    % Update the SNR/BER value
    set(handles.SNR_output,'Data',{SNR_value,bit_error;})
    
    % Plot the recevied signal
    stem(rxSequence);
end



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function SNR_value_Callback(hObject, eventdata, handles)
% hObject    handle to SNR_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SNR_value as text
%        str2double(get(hObject,'String')) returns contents of SNR_value as a double


% --- Executes during object creation, after setting all properties.
function SNR_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SNR_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bit_count_Callback(hObject, eventdata, handles)
% hObject    handle to bit_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bit_count as text
%        str2double(get(hObject,'String')) returns contents of bit_count as a double


% --- Executes during object creation, after setting all properties.
function bit_count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bit_count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
