function show_ct_image(image_descriptor, D)
    a=zeros(image_descriptor(1,1));
    i=3;
    while (i<size(image_descriptor,2))
        switch image_descriptor(1,i)
            case 0
                a=add_square(a,image_descriptor(1,i+1),image_descriptor(1,i+2),image_descriptor(1,i+3),image_descriptor(1,i+4));
                i=i+5;
            case 1
                a=add_rect(a,image_descriptor(1,i+1),image_descriptor(1,i+2),image_descriptor(1,i+3),image_descriptor(1,i+4),image_descriptor(1,i+5));
                i=i+6;
            case 2
                a=add_circle(a,image_descriptor(1,i+1),image_descriptor(1,i+2),image_descriptor(1,i+3),image_descriptor(1,i+4));
                i=i+5;
            case 3
                a=add_ellipse(a,image_descriptor(1,i+1),image_descriptor(1,i+2),image_descriptor(1,i+3),image_descriptor(1,i+4),image_descriptor(1,i+5),image_descriptor(1,i+6));
                i=i+7;
        end
    end
    colormap(gray(256));
    subplot(2,2,1)
    image(a);
    %------------------------Radonprojektion----------------------------------------------------

    dsensor3 = 0.25;
    [F3, sensor_pos3, fan_rot_angles3] = fanbeam(a,D, 'FanSensorSpacing',dsensor3);  

    figure, imagesc(fan_rot_angles3, sensor_pos3, F3)
    colormap(hot)
    colorbar
    xlabel('Fan Rotation Angle (degrees)')
    ylabel('Fan Sensor Position (degrees)')
end
