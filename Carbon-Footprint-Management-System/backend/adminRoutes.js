const express = require('express');
const mysql = require('mysql');
const app = express();

// Database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'nunez',
    database: 'icfms',
});

db.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL!');
});

// Fetch Transportation data
app.get('/admin/transportation', (req, res) => {
    const sql = `
        SELECT 
            t.transport_id, t.vehicle_type, t.distance_travelled, 
            t.fuel_consumption, i.industry_name, u.username
        FROM Transportation t
        JOIN Industries i ON t.industry_id = i.industry_id
        JOIN USER u ON i.industry_id = u.industry_id
        WHERE u.role_id IN (2, 4);`;

    db.query(sql, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Fetch Carbon Offsets data
app.get('/admin/carbon-offsets', (req, res) => {
    const sql = `
        SELECT 
            c.offset_id, c.offset_type, c.amount_offset, 
            c.date_purchased, c.provider_details, i.industry_name, u.username
        FROM Carbon_Offsets c
        JOIN Industries i ON c.industry_id = i.industry_id
        JOIN USER u ON i.industry_id = u.industry_id
        WHERE u.role_id IN (2, 4);`;

    db.query(sql, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Fetch Emission Sources data
app.get('/admin/emission-sources', (req, res) => {
    const sql = `
        SELECT 
            e.source_id, e.source_type, e.emission_value, 
            p.process_name, i.industry_name, u.username
        FROM Emission_Sources e
        JOIN Process p ON e.process_id = p.process_id
        JOIN Industries i ON e.industry_id = i.industry_id
        JOIN USER u ON i.industry_id = u.industry_id
        WHERE u.role_id IN (2, 4);`;

    db.query(sql, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Fetch Process data
app.get('/admin/processes', (req, res) => {
    const sql = `
        SELECT 
            p.process_id, p.process_name, p.energy_consumption, 
            p.emission_factor, i.industry_name, u.username
        FROM Process p
        JOIN Industries i ON p.industry_id = i.industry_id
        JOIN USER u ON i.industry_id = u.industry_id
        WHERE u.role_id IN (2, 4);`;

    db.query(sql, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

// Start server
app.listen(3000, () => {
    console.log('Server started on port 3000');
});
