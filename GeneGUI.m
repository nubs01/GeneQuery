function varargout = GeneGUI(varargin)
% GENEGUI MATLAB code for GeneGUI.fig
%      GENEGUI, by itself, creates a new GENEGUI or raises the existing
%      singleton*.
%
%      H = GENEGUI returns the handle to a new GENEGUI or the handle to
%      the existing singleton*.
%
%      GENEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENEGUI.M with the given input arguments.
%
%      GENEGUI('Property','Value',...) creates a new GENEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeneGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeneGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeneGUI

% Last Modified by GUIDE v2.5 05-Jun-2017 13:16:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeneGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GeneGUI_OutputFcn, ...
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


% --- Executes just before GeneGUI is made visible.
function GeneGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeneGUI (see VARARGIN)

% Choose default command line output for GeneGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GeneGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GeneGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;