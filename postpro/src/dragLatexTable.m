function dragLatexTable(forceData, fileName)
%DRAG LATEX TABLE - write a text file with latex table for drag contributes
%
%   syntax:
%       dragLatexTable(fileName)
%

    % open a new text file (overwrite if already exist)
    filePath = fullfile('table', fileName);
    fid = fopen(filePath, 'w');

    % check if the file has been opened correctly
    if fid == -1
        error('Can''t open the file %s for writing.', filePath);
    end

    % Intestazione della tabella
    fprintf(fid, '\\begin{table}[h!] \n');
    fprintf(fid, '\\centering \n');
    fprintf(fid, '\t \\begin{tabular}{l c c r} \n');
    fprintf(fid, '\t\t \\toprule \n');
    fprintf(fid, '\t\t \\textbf{Patch} &  $C_L$ &  $C_D$ & \\%% of Total $C_D$ \\\\ \n');
    fprintf(fid, '\t\t \\midrule \n');
    fprintf(fid, '\t\t Upper Body     &  %.3f  &  %.3f  &  %.2f\\%% \\\\ \n', forceData.upperBody.Cl,   forceData.upperBody.Cd, forceData.upperBody.Cd_absPerc);
    fprintf(fid, '\t\t Lower Body     &  %.3f  &  %.3f  &  %.2f\\%% \\\\ \n', forceData.lowerBody.Cl,   forceData.lowerBody.Cd, forceData.lowerBody.Cd_absPerc);
    fprintf(fid, '\t\t Front Tyre     &  %.3f  &  %.3f  &  %.2f\\%% \\\\ \n', forceData.frontTyre.Cl,   forceData.frontTyre.Cd, forceData.frontTyre.Cd_absPerc);
    fprintf(fid, '\t\t Rear Tyre      &  %.3f  &  %.3f  &  %.2f\\%% \\\\ \n', forceData.rearTyre.Cl,    forceData.rearTyre.Cd,  forceData.rearTyre.Cd_absPerc);
    fprintf(fid, '\t\t Spoiler        &  %.3f  &  %.3f  &  %.2f\\%% \\\\ \n', forceData.spoiler.Cl,     forceData.spoiler.Cd,   forceData.spoiler.Cd_absPerc);
    fprintf(fid, '\t\t TOTAL          &  %.3f  &  %.3f  &  %.2f\\%% \\\\ \n', forceData.overall_rel.Cl, forceData.overall_abs.Cd, 100);
    fprintf(fid, '\t\t \\toprule \n');
    fprintf(fid, '\t \\end{table} \n');
    fprintf(fid, '\\end{tabular} \n');

    % Chiude il file
    fclose(fid);

end