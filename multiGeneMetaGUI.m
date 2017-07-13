function varargout = multiGeneMetaGUI(varargin)
% MULTIGENEMETAGUI MATLAB code for multiGeneMetaGUI.fig
%      MULTIGENEMETAGUI, by itself, creates a new MULTIGENEMETAGUI or raises the existing
%      singleton*.
%
%      H = MULTIGENEMETAGUI returns the handle to a new MULTIGENEMETAGUI or the handle to
%      the existing singleton*.
%
%      MULTIGENEMETAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIGENEMETAGUI.M with the given input arguments.
%
%      MULTIGENEMETAGUI('Property','Value',...) creates a new MULTIGENEMETAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multiGeneMetaGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multiGeneMetaGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multiGeneMetaGUI

% Last Modified by GUIDE v2.5 13-Jul-2017 14:15:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @multiGeneMetaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @multiGeneMetaGUI_OutputFcn, ...
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


% --- Executes just before multiGeneMetaGUI is made visible.
function multiGeneMetaGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multiGeneMetaGUI (see VARARGIN)

% Choose default command line output for multiGeneMetaGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multiGeneMetaGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = multiGeneMetaGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);



function title_edit_Callback(hObject, eventdata, handles)
% hObject    handle to title_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of title_edit as text
%        str2double(get(hObject,'String')) returns contents of title_edit as a double
t = get(handles.title_edit,'String');
t = strrep(t,' ','-');
if ~all(isstrprop(t,'punct') == (t=='-' | t=='_'))
    errordlg('Puncation or Whitespace is not allowed in title expect _ or -');
    t(isstrprop(t,'punct') ~= (t=='-' | t=='_')) = '';
end
set(handles.title_edit,'String',t);


% --- Executes during object creation, after setting all properties.
function title_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to title_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function descrip_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descrip_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ref_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ref_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function sec_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sec_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function dir_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dir_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dir_push.
function dir_push_Callback(hObject, eventdata, handles)
% hObject    handle to dir_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fd = uigetdir('Select Save Directory for multigene expression data');
if isempty(fd)
    return;
end
set(handles.dir_edit,'String',fd);


% --- Executes on button press in addRef_push.
function addRef_push_Callback(hObject, eventdata, handles)
% hObject    handle to addRef_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
citation = inputdlg('Citation (authors, journal, year):','Add Reference',1,{'Dougherty et al, J.Neurosci, 2017'});
if isempty(citation)
    return;
end
if isempty(get(handles.ref_list,'Value')) || get(handles.ref_list,'Value')==0
    set(handles.ref_list,'Value',1)
end
set(handles.ref_list,'String',[get(handles.ref_list,'String');citation])


% --- Executes on button press in delRef_push.
function delRef_push_Callback(hObject, eventdata, handles)
% hObject    handle to delRef_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(handles.ref_list,'Value');
s = get(handles.ref_list,'String');
if numel(s)<1
    return;
end
s(a) = [];
if a>numel(s)
    a = a-1;
end
set(handles.ref_list,'String',s,'Value',a);


% --- Executes on button press in submit_push.
function submit_push_Callback(hObject, eventdata, handles)
% hObject    handle to submit_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
secPlane = get(handles.sec_pop,'String');
s = get(handles.sec_pop,'Value');
sec_plane = secPlane{s};
handles.output = struct('Title',get(handles.title_edit,'String'),...
    'Description',get(handles.descrip_edit,'String'),...
    'References',{get(handles.ref_list,'String')},...
    'Genes',[],'Section_Plane',sec_plane,'size_grid',[],...
    'save_directory',get(handles.dir_edit,'String'),...
    'expression_thresh',nan,'genes_plotted',{{}});
guidata(hObject,handles);
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles.output = [];
guidata(hObject,handles);
uiresume(handles.figure1);
