function [mean_, std_] = nanrunharmmean(z,n)
% running harmonic mean and std of z, respecting nan's.  The running harmonic
% mean is computed over n values left and right of each value of z.
% The running harmonic mean is therefore computed over a width of 2*n + 1
% samples.  If z is a matrix, the operation is performed over each column.
% Usage:  [mean_, std_] = nanrunharmmean(z,n)

% 10/28/05 jcl modify nanrunmean to nanrunharmmean
% 12/31/01 jig added std, optimized loop
% 10/15/97 mns wrote it

siz_z = size(z);

if length(siz_z) > 2
  error('input must be vector or matrix')
end
% z = [2 0 1 0 nan 1 0 0 1 3]

% z is a vector
if any(size(z)==1)
  	if nargout > 1
  		[mean_, std_] = rnanharmmeanV(z,n);
	else
  		mean_ = rnanharmmeanV(z,n);
	end

% z is a matrix. Do the operation on each column
else
  	if nargout > 1
		mean_ = nans(size(z));
		std_ = nans(size(z));
		for i = 1:siz_z(2)
			[mean_(:,i), std_(:,i)] = rnanharmmeanV(z(:,i),n);
		end
	else
		mean_ = nans(size(z));
		for i = 1:siz_z(2)
			mean_(:,i) = rnanharmmeanV(z(:,i),n);
		end
	end
end
  
function [mn,st] = rnanharmmeanV(z,n)
siz_z = size(z);			% what is size of vector we hand routine?
z = z(:)';				% force row vector
m = length(z);
q = nans(2*n + 1, length(z)+2*n+1);
for k = 0:2*n
	q(k+1,k+1:k+m) = z;
end
% compute means
mn = nanharmmean(q(:,n+1:n+m));	% a row vector
if siz_z(2) == 1
  % we handed the routine a column vector, so return the same
  mn = mn(:);
end
% compute std's
if nargout > 1
	st = nanstd(q(:,n+1:n+m));		% a row vector
	if siz_z(2) == 1
  		% we handed the routine a column vector, so return the same
  		st = st(:);
	end
end
