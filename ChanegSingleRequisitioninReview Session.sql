UPDATE RQDetail
SET RQDetail.idfRQSessionKey = 145
FROM dbo.RQDetail WITH (NOLOCK)
WHERE RQDetail.idfRQHeaderKey = <<REQ NUMBER>> --REQ #
AND RQDetail.idfRQSessionKey IN (150,155)


DELETE RQRevDtl FROM RQRevDtl 
INNER JOIN dbo.RQDetail WITH (NOLOCK) ON RQDetail.idfRQDetailKey = RQRevDtl.idfRQDetailKey
WHERE RQDetail.idfRQHeaderKey = <<REQ NUMBER>> --REQ #
AND idfRQRevHdrKey = <<REVIEW SESSION>> --REVIEW #

DELETE RQRevDtlRQHeader WHERE idfRQHeaderKey = <<REQ NUMBER>> --REQ # 
AND idfRQRevHdrKey = <<REVIEW SESSION>> --REVIEW #
