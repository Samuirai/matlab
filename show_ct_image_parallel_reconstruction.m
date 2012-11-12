
% example: show_ct_image_parallel_reconstruction(descr,1,360,1)

function show_ct_image(image_descriptor,pfrom,pto,psteps)
    global from to steps original_img text_from text_to text_steps
    from = pfrom;
    to = pto;
    steps = psteps;

    % --- create the phantom image ---
    original_img=zeros(image_descriptor(1,1));
    i=3;
    while (i<size(image_descriptor,2))
        switch image_descriptor(1,i)
            case 0
                original_img=add_square(original_img,image_descriptor(1,i+1),image_descriptor(1,i+2),image_descriptor(1,i+3),image_descriptor(1,i+4));
                i=i+5;
            case 1
                original_img=add_rect(original_img,image_descriptor(1,i+1),image_descriptor(1,i+2),image_descriptor(1,i+3),image_descriptor(1,i+4),image_descriptor(1,i+5));
                i=i+6;
            case 2
                original_img=add_circle(original_img,image_descriptor(1,i+1),image_descriptor(1,i+2),image_descriptor(1,i+3),image_descriptor(1,i+4));
                i=i+5;
            case 3
                original_img=add_ellipse(original_img,image_descriptor(1,i+1),image_descriptor(1,i+2),image_descriptor(1,i+3),image_descriptor(1,i+4),image_descriptor(1,i+5),image_descriptor(1,i+6));
                i=i+7;
        end
    end


    scan_object();

    % --- draw the gui stuff ---
    uicontrol('Style','text','Position',[30,170,480,15],'String','--- some awesome sliders ---');
    text_from = uicontrol('Style','text','Position',[30,150,120,15],'String',strcat(num2str(from),' grad'));
    text_to = uicontrol('Style','text','Position',[30,130,120,15],'String',strcat(num2str(to),' grad'));
    text_steps = uicontrol('Style','text','Position',[30,110,120,15],'String',strcat(num2str(steps),' steps'));
    uicontrol('Style','slider','Min',0,'Max',360, 'Value',from ,'SliderStep',[1/360 0.1],'Position',[150,150,360,20],'Callback',@change_from);
    uicontrol('Style','slider','Min',0,'Max',360, 'Value',to ,'SliderStep',[1/360 0.1],'Position',[150,130,360,20],'Callback',@change_to);
    uicontrol('Style','slider','Min',0,'Max',36, 'Value',steps ,'SliderStep',[0.01 0.05],'Position',[150,110,360,20],'Callback',@change_steps);
end

% --- callback for slider moving ---
function change_from(hObj,event)
    global from text_from
    from = get(hObj,'Value');
    set(text_from,'String', strcat(num2str(from),' grad'));
    scan_object();
end

% --- callback for slider moving ---
function change_to(hObj,event)
    global to text_to
    to = get(hObj,'Value');
    set(text_to,'String', strcat(num2str(to),' grad'));
    scan_object();
end

% --- callback for slider moving ---
function change_steps(hObj,event)
    global steps text_steps
    steps = get(hObj,'Value');
    set(text_steps,'String', strcat(num2str(steps),' steps'));
    scan_object();
end

% --- draws and calculates the plots ---
function [b,c,reconstructed_img] = scan_object()
    global from to steps original_img
    output_size = max(size(original_img));

    % --- do a radon scan ---
    [b,c]=radon(original_img,from:steps:to);

    % --- reconstruct image from scan ---
    reconstructed_img = iradon(b,from:steps:to,output_size);

    % --- draw the stuff ---
    colormap(gray(256));

    subplot(3,1,2)
    imagesc(from:steps:to, c, b);
    colorbar

    subplot(3,2,2);
    image(reconstructed_img);

    subplot(3,2,1)
    image(original_img);
end