const { mssql } = require('../config/db');

exports.register = async (req, res) => {
    const { first_name, last_name, email, password, role, country } = req.body;

    try {
        // Check if user exists
        const checkUser = await mssql.query`SELECT * FROM Users WHERE Email = ${email}`;
        if (checkUser.recordset.length > 0) {
            return res.status(400).json({ status: 'error', message: 'User already exists' });
        }

        // Insert new user
        // Note: In a real app, you should hash the password!
        await mssql.query`
            INSERT INTO Users (FirstName, LastName, Email, Password, Role, Country)
            VALUES (${first_name}, ${last_name}, ${email}, ${password}, ${role}, ${country})
        `;

        res.status(201).json({ status: 'success', message: 'User registered successfully' });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ status: 'error', message: 'Server error' });
    }
};

exports.login = async (req, res) => {
    const { email, password } = req.body;

    try {
        const result = await mssql.query`SELECT * FROM Users WHERE Email = ${email} AND Password = ${password}`;
        
        if (result.recordset.length === 0) {
            return res.status(401).json({ status: 'error', message: 'Invalid credentials' });
        }

        res.json({ status: 'success', message: 'Login successful', user: result.recordset[0] });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ status: 'error', message: 'Server error' });
    }
};
