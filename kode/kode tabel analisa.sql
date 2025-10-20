CREATE TABLE `kimia_farma.analisa` AS
SELECT 
    -- Kolom mandatory dari kf_final_transaction
    ft.transaction_id,
    ft.date,
    ft.branch_id,
    ft.customer_name,
    ft.product_id,
    ft.discount_percentage,
    ft.rating AS rating_transaksi,
    
    -- Kolom dari kf_kantor_cabang
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    
    -- Kolom dari kf_product
    p.product_name,
    p.price AS actual_price,
    
    -- Perhitungan persentase gross laba berdasarkan ketentuan
    CASE 
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
    END AS persentase_gross_laba,
    
    -- Perhitungan nett_sales (harga setelah diskon)
    p.price * (1 - ft.discount_percentage/100) AS nett_sales,
    
    -- Perhitungan nett_profit (keuntungan setelah diskon)
    (p.price * (1 - ft.discount_percentage/100)) * 
    CASE 
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
    END AS nett_profit

FROM `kimia_farma.kf_final_transaction` ft
LEFT JOIN `kimia_farma.kf_kantor_cabang` kc 
    ON ft.branch_id = kc.branch_id
LEFT JOIN `kimia_farma.kf_product` p 
    ON ft.product_id = p.product_id;