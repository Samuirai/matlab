
% example: show_ct_image_fan_reconstruction(descr,1,360,200,360)

function show_ct_image(image_descriptor,pfrom,pto,pdistance,psteps)
    global from to steps distance original_img text_from text_to text_distance text_steps
    from = pfrom;
    to = pto;
    distance = pdistance;
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
    uicontrol('Style','text','Position',[30,190,480,15],'String','--- some awesome sliders ---');
    text_distance = uicontrol('Style','text','Position',[30,170,120,15],'String',strcat(num2str(distance),' px'));
    text_from = uicontrol('Style','text','Position',[30,150,120,15],'String',strcat(num2str(from),' grad'));
    text_to = uicontrol('Style','text','Position',[30,130,120,15],'String',strcat(num2str(to),' grad'));
    text_steps = uicontrol('Style','text','Position',[30,110,120,15],'String',strcat(num2str(steps),'/360 steps'));
    uicontrol('Style','slider','Min',1,'Max',1000, 'Value',distance ,'SliderStep',[1/1000 0.01],'Position',[150,170,360,15],'Callback',@change_distance);
    uicontrol('Style','slider','Min',1,'Max',360, 'Value',from ,'SliderStep',[1/360 0.1],'Position',[150,150,360,15],'Callback',@change_from);
    uicontrol('Style','slider','Min',1,'Max',360, 'Value',to ,'SliderStep',[1/360 0.1],'Position',[150,130,360,15],'Callback',@change_to);
    uicontrol('Style','edit', 'Value',steps,'Position',[150,110,360,20],'Callback',@change_steps);

end

% --- callback for slider moving ---
function change_distance(hObj,event)
    global distance text_distance
    distance = get(hObj,'Value');
    set(text_distance,'String', strcat(num2str(distance),' px'));
    scan_object();
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
    steps = str2num(get(hObj,'String'));
    set(text_steps,'String', strcat(num2str(steps),'/360 steps'));
    scan_object();
end

% --- draws and calculates the plots ---
function scan_object()
    global from to distance original_img steps
    output_size = max(size(original_img));
    
    % --- do a fan scan ---
    %[b,c]=radon(original_img,from:to);
    [b, sensor_pos3, fan_rot_angles3] = fanbeam(original_img, distance, 'FanSensorSpacing',0.25, 'FanRotationIncrement',steps/360);
    b = b(:,round(from):round(to));
    % --- reconstruct image from scan ---
    reconstructed_img = ifanbeam(b,distance,'FanSensorSpacing',0.25,'OutputSize',output_size, 'FanRotationIncrement',steps/360);
    
    % --- draw the stuff ---
    colormap(gray(256));
    
    subplot(3,1,2)
    imagesc(fan_rot_angles3, sensor_pos3, b);
    
    colorbar
    subplot(3,2,2);
    image(reconstructed_img);
    
    subplot(3,2,1)
    image(original_img);
end