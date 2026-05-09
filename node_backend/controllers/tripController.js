const { mssql } = require('../config/db');

const parseTrip = (record) => ({
  id: record.Id,
  location: record.Location,
  date: record.Date,
  timeFrom: record.TimeFrom,
  timeTo: record.TimeTo,
  travelers: record.Travelers,
  fee: parseFloat(record.Fee),
  language: record.Language,
  attractions: record.Attractions,
  status: record.Status,
  createdAt: record.CreatedAt,
});

exports.getAllTrips = async (req, res) => {
  try {
    const { page = 1, limit = 20, search = '' } = req.query;
    const offset = (page - 1) * limit;

    const pool = await mssql.connect();
    const request = pool.request();

    const searchValue = `%${search}%`;

    const countResult = await request
      .input('search', mssql.NVarChar(255), searchValue)
      .query(`
        SELECT COUNT(*) AS total
        FROM Trips
        WHERE IsDeleted = 0
          AND (Location LIKE @search OR Attractions LIKE @search OR Status LIKE @search)
      `);

    const total = countResult.recordset[0].total;

    const result = await request
      .input('offset', mssql.Int, offset)
      .input('limit', mssql.Int, limit)
      .query(`
        SELECT Id, Location, Date, TimeFrom, TimeTo, Travelers, Fee, Language, Attractions, Status, CreatedAt
        FROM Trips
        WHERE IsDeleted = 0
          AND (Location LIKE @search OR Attractions LIKE @search OR Status LIKE @search)
        ORDER BY CreatedAt DESC
        OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY
      `);

    res.json({
      success: true,
      data: result.recordset.map(parseTrip),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('Error fetching trips:', error.message);
    res.status(500).json({ success: false, error: error.message });
  }
};

exports.getTripById = async (req, res) => {
  try {
    const { id } = req.params;
    const pool = await mssql.connect();
    const request = pool.request();

    const result = await request
      .input('id', mssql.Int, id)
      .query(`
        SELECT Id, Location, Date, TimeFrom, TimeTo, Travelers, Fee, Language, Attractions, Status, CreatedAt
        FROM Trips
        WHERE Id = @id AND IsDeleted = 0
      `);

    if (result.recordset.length === 0) {
      return res.status(404).json({ success: false, error: 'Trip not found' });
    }

    res.json({ success: true, data: parseTrip(result.recordset[0]) });
  } catch (error) {
    console.error('Error fetching trip:', error.message);
    res.status(500).json({ success: false, error: error.message });
  }
};

exports.createTrip = async (req, res) => {
  try {
    const {
      location,
      date,
      timeFrom,
      timeTo,
      travelers,
      fee,
      language,
      attractions,
      status,
      createdAt,
    } = req.body;

    if (!location || !date || !timeFrom || !timeTo || travelers == null || fee == null || !language || !attractions || !status) {
      return res.status(400).json({ success: false, error: 'Missing required trip fields' });
    }

    const pool = await mssql.connect();
    const request = pool.request();

    const newTrip = await request
      .input('location', mssql.NVarChar(255), location.trim())
      .input('date', mssql.NVarChar(50), date.trim())
      .input('timeFrom', mssql.NVarChar(50), timeFrom.trim())
      .input('timeTo', mssql.NVarChar(50), timeTo.trim())
      .input('travelers', mssql.Int, parseInt(travelers, 10))
      .input('fee', mssql.Decimal(10, 2), parseFloat(fee))
      .input('language', mssql.NVarChar(100), language.trim())
      .input('attractions', mssql.NVarChar(mssql.MAX), attractions.trim())
      .input('status', mssql.NVarChar(50), status.trim())
      .input('createdAt', mssql.NVarChar(50), createdAt ? createdAt.trim() : new Date().toISOString())
      .query(`
        INSERT INTO Trips (
          Location, Date, TimeFrom, TimeTo, Travelers, Fee,
          Language, Attractions, Status, CreatedAt, IsDeleted
        )
        OUTPUT INSERTED.Id
        VALUES (
          @location, @date, @timeFrom, @timeTo, @travelers, @fee,
          @language, @attractions, @status, @createdAt, 0
        )
      `);

    res.status(201).json({
      success: true,
      message: 'Trip created successfully',
      data: { id: newTrip.recordset[0].Id },
    });
  } catch (error) {
    console.error('Error creating trip:', error.message);
    res.status(500).json({ success: false, error: error.message });
  }
};

exports.updateTrip = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      location,
      date,
      timeFrom,
      timeTo,
      travelers,
      fee,
      language,
      attractions,
      status,
      createdAt,
    } = req.body;

    if (!location || !date || !timeFrom || !timeTo || travelers == null || fee == null || !language || !attractions || !status) {
      return res.status(400).json({ success: false, error: 'Missing required trip fields' });
    }

    const pool = await mssql.connect();
    const request = pool.request();

    const result = await request
      .input('id', mssql.Int, id)
      .input('location', mssql.NVarChar(255), location.trim())
      .input('date', mssql.NVarChar(50), date.trim())
      .input('timeFrom', mssql.NVarChar(50), timeFrom.trim())
      .input('timeTo', mssql.NVarChar(50), timeTo.trim())
      .input('travelers', mssql.Int, parseInt(travelers, 10))
      .input('fee', mssql.Decimal(10, 2), parseFloat(fee))
      .input('language', mssql.NVarChar(100), language.trim())
      .input('attractions', mssql.NVarChar(mssql.MAX), attractions.trim())
      .input('status', mssql.NVarChar(50), status.trim())
      .input('createdAt', mssql.NVarChar(50), createdAt ? createdAt.trim() : new Date().toISOString())
      .query(`
        UPDATE Trips
        SET
          Location = @location,
          Date = @date,
          TimeFrom = @timeFrom,
          TimeTo = @timeTo,
          Travelers = @travelers,
          Fee = @fee,
          Language = @language,
          Attractions = @attractions,
          Status = @status,
          CreatedAt = @createdAt
        WHERE Id = @id AND IsDeleted = 0
      `);

    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ success: false, error: 'Trip not found or already deleted' });
    }

    res.json({ success: true, message: 'Trip updated successfully' });
  } catch (error) {
    console.error('Error updating trip:', error.message);
    res.status(500).json({ success: false, error: error.message });
  }
};

exports.deleteTrip = async (req, res) => {
  try {
    const { id } = req.params;
    const pool = await mssql.connect();
    const request = pool.request();

    const result = await request
      .input('id', mssql.Int, id)
      .query(`
        UPDATE Trips
        SET IsDeleted = 1
        WHERE Id = @id AND IsDeleted = 0
      `);

    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ success: false, error: 'Trip not found or already deleted' });
    }

    res.json({ success: true, message: 'Trip deleted successfully' });
  } catch (error) {
    console.error('Error deleting trip:', error.message);
    res.status(500).json({ success: false, error: error.message });
  }
};
