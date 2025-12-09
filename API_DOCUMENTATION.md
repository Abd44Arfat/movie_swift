# API Documentation

This document describes the API endpoints used by the Movie Booking iOS app.

## Base URL

```
http://localhost:3000
```

For physical devices, replace `localhost` with your Mac's IP address (e.g., `http://192.168.1.5:3000`).

## Authentication

Most endpoints require JWT authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

The app automatically handles token storage and injection for authenticated requests.

---

## Endpoints

### Authentication

#### Register User

**POST** `/auth/register`

Creates a new user account.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

---

#### Login User

**POST** `/auth/login`

Authenticates a user and returns a JWT token.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

---

### Movies

#### Get All Movies

**GET** `/movies`

Retrieves all available movies.

**Response:**
```json
[
  {
    "_id": "507f1f77bcf86cd799439011",
    "title": "Inception",
    "posterUrl": "http://localhost:3000/uploads/inception.jpg",
    "genre": ["Action", "Sci-Fi", "Thriller"],
    "description": "A thief who steals corporate secrets through dream-sharing technology...",
    "duration": "2h 28m",
    "rating": 8.8,
    "releaseDate": "2010-07-16T00:00:00.000Z",
    "price": 12.99,
    "showtimes": ["10:00", "14:00", "18:00", "21:00"]
  }
]
```

---

#### Get Movie by ID

**GET** `/movies/:id`

Retrieves a specific movie by its ID.

**Response:**
```json
{
  "_id": "507f1f77bcf86cd799439011",
  "title": "Inception",
  "posterUrl": "http://localhost:3000/uploads/inception.jpg",
  "genre": ["Action", "Sci-Fi", "Thriller"],
  "description": "A thief who steals corporate secrets through dream-sharing technology...",
  "duration": "2h 28m",
  "rating": 8.8,
  "releaseDate": "2010-07-16T00:00:00.000Z",
  "price": 12.99,
  "showtimes": ["10:00", "14:00", "18:00", "21:00"]
}
```

---

### Bookings

#### Get Available Seats

**GET** `/bookings/available-seats`

Retrieves available seats for a specific movie and date.

**Query Parameters:**
- `movieId` (required): The ID of the movie
- `date` (required): Date in ISO format (e.g., "2025-12-15")

**Example:**
```
GET /bookings/available-seats?movieId=507f1f77bcf86cd799439011&date=2025-12-15
```

**Response:**
```json
{
  "availableSeats": ["A1", "A2", "A3", "B1", "B2", "C1", "C2", "C3"]
}
```

---

#### Create Booking

**POST** `/bookings`

Creates a new movie booking.

**Authentication:** Required

**Request Body:**
```json
{
  "movieId": "507f1f77bcf86cd799439011",
  "date": "2025-12-15",
  "time": "18:00",
  "seats": ["A1", "A2"],
  "totalPrice": 25.98,
  "location": "Cinema Hall 1"
}
```

**Response:**
```json
{
  "_id": "507f191e810c19729de860ea",
  "movie": "507f1f77bcf86cd799439011",
  "userId": "507f1f77bcf86cd799439012",
  "date": "2025-12-15",
  "time": "18:00",
  "seats": ["A1", "A2"],
  "totalPrice": 25.98,
  "location": "Cinema Hall 1",
  "createdAt": "2025-12-09T05:55:53.000Z"
}
```

---

#### Get My Bookings

**GET** `/bookings/my-bookings`

Retrieves all bookings for the authenticated user.

**Authentication:** Required

**Response:**
```json
[
  {
    "_id": "507f191e810c19729de860ea",
    "movie": {
      "_id": "507f1f77bcf86cd799439011",
      "title": "Inception",
      "posterUrl": "http://localhost:3000/uploads/inception.jpg",
      "genre": ["Action", "Sci-Fi", "Thriller"],
      "rating": 8.8
    },
    "date": "2025-12-15",
    "time": "18:00",
    "seats": ["A1", "A2"],
    "totalPrice": 25.98,
    "location": "Cinema Hall 1"
  }
]
```

---

## Error Responses

All endpoints may return the following error responses:

### 400 Bad Request
```json
{
  "message": "Validation error message"
}
```

### 401 Unauthorized
```json
{
  "message": "Invalid or missing authentication token"
}
```

### 404 Not Found
```json
{
  "message": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "message": "Internal server error"
}
```

---

## Data Models

### Movie
```typescript
{
  _id: string
  title: string
  posterUrl: string
  genre: string[]
  description?: string
  duration?: string
  rating?: number
  releaseDate?: string
  price?: number
  showtimes?: string[]
}
```

### Booking
```typescript
{
  _id: string
  movie: string | Movie
  userId: string
  date: string
  time: string
  seats: string[]
  totalPrice: number
  location: string
  createdAt: string
}
```

### User
```typescript
{
  _id: string
  name: string
  email: string
  password: string (hashed)
  createdAt: string
}
```

---

## Notes

1. **Date Format**: All dates should be in ISO 8601 format (e.g., "2025-12-15T00:00:00.000Z")
2. **Image URLs**: Poster URLs are served from the backend's `/uploads` directory
3. **Authentication**: JWT tokens are stored in UserDefaults with key "auth_token"
4. **Seat Format**: Seats are represented as strings (e.g., "A1", "B2", "C3")
5. **Price Calculation**: Total price is calculated on the backend based on movie price and number of seats
