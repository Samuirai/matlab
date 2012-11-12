function show_ct_image_with_radon_fan_beam(image_descriptor, pInc, pStart, pDelta, pDistance)
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
    
    [F3, sensor_pos3, fan_rot_angles3] = fanbeam(a,pDistance, 'FanSensorSpacing',pInc)  
     
    
    subplot(2,2,2)
    plot(sensor_pos3, F3(:,(pStart+1)) )

    subplot(2,2,4)
    plot(sensor_pos3, F3(:,(pStart+pDelta+1)))
end
