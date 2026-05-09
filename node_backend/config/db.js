const mssql = require('mssql');
require('dotenv').config();

const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    options: {
        encrypt: true, // For azure
        trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === 'true'
    }
};

const ensureTripTable = async () => {
    const pool = await mssql.connect();
    await pool.request().query(`
        IF NOT EXISTS (
            SELECT 1 FROM sys.objects
            WHERE object_id = OBJECT_ID(N'[dbo].[Trips]') AND type = N'U'
        )
        BEGIN
            CREATE TABLE dbo.Trips (
                Id INT IDENTITY(1,1) PRIMARY KEY,
                Location NVARCHAR(255) NOT NULL,
                Date NVARCHAR(50) NOT NULL,
                TimeFrom NVARCHAR(50) NOT NULL,
                TimeTo NVARCHAR(50) NOT NULL,
                Travelers INT NOT NULL,
                Fee DECIMAL(10, 2) NOT NULL,
                Language NVARCHAR(100) NOT NULL,
                Attractions NVARCHAR(MAX) NOT NULL,
                Status NVARCHAR(50) NOT NULL,
                CreatedAt NVARCHAR(50) NOT NULL,
                IsDeleted BIT NOT NULL DEFAULT 0
            );
        END
    `);
};

const connectDB = async () => {
    try {
        await mssql.connect(config);
        console.log('SQL Server Connected...');
        await ensureTripTable();
    } catch (err) {
        console.error('Database connection failed:', err.message);
        process.exit(1);
    }
};

module.exports = { mssql, connectDB };
