function k = vortex(xc_front, xc_back, m, p, alpha, Uinf, theta_front, theta_back)
% this programe aims to evalutae the vorteces strength at each location
% specified of a discretized naca profile

% Transforme the xc coordinate into angle of a cercle (with 0 at the
% leading edge and pi at the trailing edge
    theta_xc_front = acos(1-2.*xc_front);
    theta_xc_back = acos(1-2.*xc_back);

% computation of the effective angle of attack (angle between the chord and
% the incident horizontal flow
    alpha_eff_front = alpha  ;%+ theta_front ;
    alpha_eff_back = alpha   ;%+ theta_back ;

% Compute A0 and An
    n = 5 ; % number of term in the Fourier transform after 25 it is around 0 at 10^(-4)
    [A0, An] = A_n_computation(m, p, n);

% computation of k1 :
    k1_front = 2.*Uinf.*(alpha_eff_front-A0).*(1./tan(theta_xc_front)) ;
    k1_back = 2.*Uinf.*(alpha_eff_back-A0).*(1./tan(theta_xc_back)) ;

% computation of k2 :
    k2_front = 2 * Uinf .* (alpha_eff_front - A0)./sin(theta_xc_front) ;
    k2_back = 2 * Uinf .* (alpha_eff_back - A0)./sin(theta_xc_back) ;

% computation of k3 : 
    k3_front = zeros(1,length(theta_xc_front)) ; % initialisation
    k3_back = zeros(1,length(theta_xc_back)) ; % initialisation
    for i=1:n
        k3_front = k3_front + 2.*Uinf.* sin(i*theta_xc_front)*An(i); 
        k3_back = k3_back + 2.*Uinf.* sin(i*theta_xc_back)*An(i);
    end
    


% get back the total k :
    k_front = k1_front + k2_front + k3_front ;
    k_back = k1_back + k2_back + k3_back;
    k_back(end) = 0 ; % BC condition
    k_front(1) = k_front(2) ; % to avoid singularity to numeric problem

    k =  [k_front, k_back] ;
end