# Aletheia v2 System Architecture

## High-Level Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   User Profile  │    │   Whisper       │    │   Revelation    │
│   Management    │    │   Engine        │    │   Engine        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Core Aletheia Engine                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Oracle    │  │ Archetype   │  │    Codex    │            │
│  │   Engine    │  │   Engine    │  │  Management │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Integration Layer                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │ Meta Graph  │  │ TrafficFloU │  │   Athena    │            │
│  │     API     │  │ Integration │  │     PR      │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Buffer    │  │ Aletheia    │  │   Voice     │            │
│  │     API     │  │  Archive    │  │  Matrix     │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Data Layer                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│  │   Supabase  │  │    Redis    │  │  Analytics  │            │
│  │  Database   │  │   Cache     │  │   Engine    │            │
│  └─────────────┘  └─────────────┘  └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### 1. Core Engines

#### Oracle Engine
- **Purpose**: Central AI processing for user queries
- **Dependencies**: UserProfile, SecureStorage
- **Key Features**:
  - Query processing and response generation
  - Profile-based personalization
  - Error handling and status management
- **Data Flow**: User Input → Profile Context → AI Processing → Response

#### Whisper Engine
- **Purpose**: Spiritual prompt generation and management
- **Dependencies**: UserProfile, Whisper, WhisperCategory
- **Key Features**:
  - Dynamic whisper generation
  - Lockout mechanism for skipped whispers
  - Category-based filtering
- **Data Flow**: User Journey → Whisper Generation → Response Collection → Archive

#### Revelation Engine
- **Purpose**: Sacred revelation generation from user responses
- **Dependencies**: UserProfile, Whisper, Revelation
- **Key Features**:
  - Response analysis and mood determination
  - Template-based revelation generation
  - Sigil generation for deep responses
- **Data Flow**: Whisper Response → Analysis → Mood Selection → Revelation Generation

#### Archetype Engine
- **Purpose**: Spiritual archetype awakening and tracking
- **Dependencies**: Codex, Archetype, SecureStorage
- **Key Features**:
  - Unlock condition monitoring
  - Emotional weight calculation
  - Archetype progression tracking
- **Data Flow**: User Journey → Condition Check → Archetype Unlock → Notification

#### Codex Engine
- **Purpose**: Sacred revelation storage and organization
- **Dependencies**: SealedRevelation, Chapter, SecureStorage
- **Key Features**:
  - Chapter and page organization
  - Secure revelation sealing
  - Historical journey tracking
- **Data Flow**: Revelation → Sealing → Chapter Assignment → Storage

### 2. Integration Layer

#### Meta Graph API Integration
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   OAuth     │───▶│ Account     │───▶│ Content     │
│  Flow       │    │ Discovery   │    │ Publishing  │
└─────────────┘    └─────────────┘    └─────────────┘
```

#### TrafficFloU Integration
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Performance │───▶│ Webhook     │───▶│ Funnel      │
│ Monitoring  │    │ Handler     │    │ Trigger     │
└─────────────┘    └─────────────┘    └─────────────┘
```

#### Athena PR Monitoring
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Content     │───▶│ Sentiment   │───▶│ Response    │
│ Analysis    │    │ Detection   │    │ Generation  │
└─────────────┘    └─────────────┘    └─────────────┘
```

### 3. Data Layer

#### Supabase Database Schema
```sql
-- User profiles and authentication
users (
  id, name, purpose, offering, created_at, updated_at
)

-- Content vault for all generated content
content_vault (
  id, account_name, content_type, content_data, 
  voice_matrix, performance_metrics, created_at
)

-- Performance tracking
performance_metrics (
  id, post_id, account_name, impressions, reach,
  dms, link_clicks, saves, conversion_rate, recorded_at
)

-- Whisper and revelation tracking
whispers (
  id, question, category, response, answered_at, user_id
)

revelations (
  id, text, sigil, mood, whisper_id, sealed_at, user_id
)

-- Archetype progression
archetypes (
  id, name, description, unlocked, unlocked_at, user_id
)
```

#### Redis Caching Strategy
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Content       │    │   Performance   │    │   User          │
│   Cache         │    │   Metrics       │    │   Sessions      │
│   (1 hour)      │    │   (30 min)      │    │   (24 hours)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Data Flow Architecture

### 1. User Journey Flow
```
User Registration → Profile Creation → Whisper Generation → 
Response Collection → Revelation Generation → Codex Sealing → 
Archetype Progression → Social Media Integration
```

### 2. Content Generation Flow
```
Account Selection → Voice Matrix → Content Type → 
AI Generation → Performance Prediction → Scheduling → 
Publication → Analytics Collection → Optimization
```

### 3. Integration Flow
```
Performance Data → Webhook Trigger → TrafficFloU → 
Funnel Activation → Lead Capture → Revenue Tracking
```

## Security Architecture

### 1. Authentication & Authorization
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   OAuth     │───▶│   JWT       │───▶│   Role      │
│  2.0 Flow   │    │  Tokens     │    │  Based      │
└─────────────┘    └─────────────┘    └─────────────┘
```

### 2. Data Encryption
- **At Rest**: AES-256 encryption for all sensitive data
- **In Transit**: TLS 1.3 for all API communications
- **Key Management**: Secure keychain storage with rotation

### 3. Access Control
- **User Roles**: Admin, Editor, Viewer
- **Resource Permissions**: Read, Write, Delete, Configure
- **API Rate Limiting**: Per-user and per-endpoint limits

## Performance Architecture

### 1. Caching Strategy
- **L1 Cache**: Redis for frequently accessed data
- **L2 Cache**: Supabase for persistent storage
- **CDN**: Global content delivery for media assets

### 2. Load Balancing
- **Horizontal Scaling**: Multiple application instances
- **Database Sharding**: Account-based data distribution
- **Queue Management**: Background job processing

### 3. Monitoring & Analytics
- **Real-time Metrics**: Performance tracking and alerting
- **Error Tracking**: Comprehensive logging and debugging
- **User Analytics**: Journey tracking and optimization

## Deployment Architecture

### 1. Environment Structure
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Development   │    │   Staging       │    │   Production    │
│   Environment   │    │   Environment   │    │   Environment   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 2. Container Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   Container     │    │   Container     │    │   Container     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 3. CI/CD Pipeline
```
Code Commit → Automated Testing → Security Scan → 
Build & Package → Deploy to Staging → 
Integration Testing → Deploy to Production
```

## Scalability Considerations

### 1. Horizontal Scaling
- **Application**: Multiple instances behind load balancer
- **Database**: Read replicas and connection pooling
- **Cache**: Redis cluster for high availability

### 2. Vertical Scaling
- **Compute**: CPU and memory optimization
- **Storage**: SSD storage for high I/O performance
- **Network**: High-bandwidth connections

### 3. Geographic Distribution
- **CDN**: Global content delivery
- **Database**: Multi-region deployment
- **API**: Edge computing for low latency

## Disaster Recovery

### 1. Backup Strategy
- **Database**: Automated daily backups with point-in-time recovery
- **Files**: Redundant storage across multiple regions
- **Configuration**: Version-controlled configuration management

### 2. Failover Strategy
- **Primary/Secondary**: Automatic failover between regions
- **Data Replication**: Real-time data synchronization
- **Monitoring**: Automated health checks and alerting

### 3. Recovery Procedures
- **RTO**: 15 minutes for critical systems
- **RPO**: 5 minutes for data loss prevention
- **Testing**: Monthly disaster recovery drills 