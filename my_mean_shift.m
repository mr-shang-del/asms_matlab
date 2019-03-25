function [pos_new, scale] = my_mean_shift(im, pos, target_sz, q_hist, b_hist ,wAvgBg, bound1, bound2)
    h0 = 1;
    border = [5,5];
    for ii=1:15
        candidate_sz = floor(target_sz+2*border);
        kernel = kernel_Epanechnikov(candidate_sz);
        kernel_deriv = kernel_Epanechnikov_deriv(candidate_sz);
        [y_n, x_n] = ndgrid((1:candidate_sz(1)) - floor(candidate_sz(1)/2), (1:candidate_sz(2)) - floor(candidate_sz(2)/2));
        dist = y_n.^2 + x_n.^2;
        
        target_patch = crop_patch(im, pos, candidate_sz);
        y1_hist = color_histogram(target_patch, 1);
        batta_q = compute_battacharyya(q_hist, y1_hist);
        batta_b = compute_battacharyya(b_hist, y1_hist);
        q_table = sqrt(q_hist ./ y1_hist);
        b_table = sqrt(b_hist ./ y1_hist);
        wqi = weight_image(q_table, target_patch);
        wbi = weight_image(b_table, target_patch);
        w = max(wqi./batta_q-wbi./batta_b, 0);
        wg = w .* (-kernel_deriv);
        wy1 = weight_image(y1_hist, target_patch);
        wq = weight_image(q_hist, target_patch);
        Sbg = sum(sum(wy1(find(wqi<wbi))));
        Sfg = sum(sum(wq));
        m0 = sum(sum(wg));
        m1x = sum(sum(y_n .* wg));
        m1y = sum(sum(x_n .* wg));
        
        pos_tmp = pos + [m1y/m0, m1x/m0];

        reg1 = wAvgBg - Sbg/Sfg;
        if abs(reg1)>bound1
            reg1 = sign(reg1)*bound1;
        end

        reg2 = - log(h0);
        if abs(reg2)>bound2
            reg2 = sign(reg2)*bound2;
        end
        
        wk = w .* kernel;
        wg_dist = wg .* dist;
        h_tmp = (1-sum(wk(:))/m0)*h0+(sum(wg_dist(:))/m0)/h0+reg1+reg2;
        
        if sum((pos_tmp-pos).^2)<0.1
            break
        end
        
        if (~isinf(m0)) && (m0>0)
            pos = pos_tmp;
            h0 = 0.7*h0+0.3*h_tmp;
            if border(1)>5
                border = border/3;
            end
        elseif ii==1
            border = border*3;
        end
    end
    pos_new = pos;
    scale = h0;
end

