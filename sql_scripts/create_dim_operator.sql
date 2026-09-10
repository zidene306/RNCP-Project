USE mobile_5g_network_fr;

INSERT INTO dim_operator (
    operator_id,
    code_op,
    operator_name
)
VALUES
    (1, 20801, 'Orange'),
    (2, 20810, 'SFR'),
    (3, 20815, 'Free Mobile'),
    (4, 20820, 'Bouygues Telecom');

SELECT * FROM dim_operator;