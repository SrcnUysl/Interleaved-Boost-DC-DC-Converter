%% Converter control initialization (idealized, matched phases)

% ========== Devre parametreleri ==========
Vin  = 14;
Vo   = 24;
Pout = 240;

Llk  = 3e-6;     % H
Co   = 754e-6;    % F

% hedef bant genişlikleri (sen belirle)
fci = 10000;    % iç akım loop crossover hedefi
fcv = 550;     % dış voltaj loop crossover hedefi

% ========== Türetilenler ==========
Rout = Vo^2 / Pout;
D    = 1 - (Vin/Vo);

Iout = Pout/Vo;
IL1  = Iout / (2*(1-D));   % her faz ortalama endüktör akımı (ideal)

s = tf('s');

% ========== Transfer fonksiyonları (senin paylaştığın formülle aynı yapı) ==========
gamma1 = Vo;
beta1  = -(1-D);
beta2  = -1/Rout;
gamma2 = -2*IL1;
delta2 = 2*(1-D);

% Duty -> iL1
numGcf = s*Co*gamma1 - gamma1*beta2 + gamma2*beta1;
denGcf = s^2*Llk*Co - s*(Llk*beta2) + (-beta1*delta2);
Gcf = numGcf/denGcf;

% iL1 -> Vo
numGVof = s*Llk*gamma2 - gamma1*delta2;
denGVof = s*Co*gamma1 + (beta1*gamma2 - beta2*gamma1);
GVof = numGVof/denGVof;

GVof = -GVof;  % senin işaret düzeltmesi

% ========== İç loop PI (Kp_i, Ki_i) ==========
wci = 2*pi*fci;
mag_i = abs(squeeze(freqresp(Gcf, wci)));

Kp_i = 1/mag_i;
wzi  = wci/10;          % iç loop zero (kural)
Ki_i = Kp_i*wzi;

% ========== İç loop kapalı çevrim Ti ==========
Ci = Kp_i + Ki_i/s;
Ti = feedback(Ci*Gcf, 1);

% ========== Dış loop PI (Kp_v, Ki_v) ==========
Gv = Ti*GVof;

wcv = 2*pi*fcv;
wzv = wcv/3;             % dış loop zero (kural)
Cv_shape = (1 + wzv/s);

mag_v = abs(squeeze(freqresp(Cv_shape*Gv, wcv)));

Kp_v = 1/mag_v;
Ki_v = Kp_v*wzv;

% ========== Workspace'e bırak ==========
assignin('base','Vin',Vin);
assignin('base','Vo',Vo);
assignin('base','Pout',Pout);
assignin('base','Llk',Llk);
assignin('base','Co',Co);
assignin('base','Rout',Rout);
assignin('base','D',D);

assignin('base','Gcf',Gcf);
assignin('base','GVof',GVof);
assignin('base','Ti',Ti);
assignin('base','Gv',Gv);

assignin('base','Kp_i',Kp_i);
assignin('base','Ki_i',Ki_i);
assignin('base','Kp_v',Kp_v);
assignin('base','Ki_v',Ki_v);

% Gcf (duty -> iL1)
[numGcf, denGcf] = tfdata(Gcf,'v');
assignin('base','numGcf', numGcf);
assignin('base','denGcf', denGcf);

% GVof (iL1 -> vout)
[numGVof, denGVof] = tfdata(GVof,'v');
assignin('base','numGVof', numGVof);
assignin('base','denGVof', denGVof);

% (Opsiyonel) ekrana yazdır: kontrol amaçlı
disp("numGcf = "); disp(numGcf);
disp("denGcf = "); disp(denGcf);
disp("numGVof = "); disp(numGVof);
disp("denGVof = "); disp(denGVof);
Tsw = 10e-6;


% ===== TUSTIN (BILINEAR) AYRIKLAŞTIRMA HESAPLARI =====
Ts_i = 1/100000; % İç döngü 100 kHz (10 us)
Ts_v = 1/10000;  % Dış döngü 10 kHz (100 us)

% İç Döngü q0 ve q1 (Tustin)
q0_i = Kp_i + (Ki_i * Ts_i / 2);
q1_i = -Kp_i + (Ki_i * Ts_i / 2);

% Dış Döngü q0 ve q1 (Tustin)
q0_v = Kp_v + (Ki_v * Ts_v / 2);
q1_v = -Kp_v + (Ki_v * Ts_v / 2);

% C/C++ Kodu İçin Ekrana Yazdır
fprintf('\n--- TUSTIN C KODU KATSAYILARI ---\n');
fprintf('const float q0_i = %.8f; \nconst float q1_i = %.8f;\n', q0_i, q1_i);
fprintf('const float q0_v = %.8f; \nconst float q1_v = %.8f;\n', q0_v, q1_v);